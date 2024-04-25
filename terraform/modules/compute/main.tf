locals {
  // Determine if encryption is enabled and if a key is available
  cmk_encryption_enabled = var.key_vault_resource_group_name != null && var.key_vault_disk_encrytion_id != null ? 1 : 0

  // Dynamic configuration for VM tags
  vm_tags = merge(var.common_tags,
    {
      managedby = "terraform"
    }
  )
}

data "azurerm_client_config" "current" {}

data "azurerm_shared_image_gallery" "image_gallery" {
  name                = var.shared_image_gallery_name
  resource_group_name = var.image_gallery_resource_group_name
}

data "azurerm_shared_image_version" "image_version" {
  name                = var.shared_image_version
  image_name          = var.shared_image_name
  gallery_name        = data.azurerm_shared_image_gallery.image_gallery.name
  resource_group_name = data.azurerm_shared_image_gallery.image_gallery.resource_group_name
}

// Required only if disk encryption is enabled (true) to specify the customer-managed key (CMK).
data "azurerm_key_vault" "import_key" {
  count = local.cmk_encryption_enabled

  name                = split(".", split("/", var.key_vault_disk_encrytion_id)[2])[0]
  resource_group_name = var.key_vault_resource_group_name
}

## Creates the VM NIC 
resource "azurerm_network_interface" "nic" {
  count               = var.windows_vm_count
  name                = "${var.vm_name}-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-i-${count.index}"
    subnet_id                     = var.subnet_ids[count.index % length(var.subnet_ids)]
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.vm_tags
}

## Azure Disk encryption Set - Required only if disk encryption is enabled (true) to specify the customer-managed key (CMK).
resource "azurerm_disk_encryption_set" "des" {
  count = local.cmk_encryption_enabled

  name                = "${var.vm_name}-des"
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = var.key_vault_disk_encrytion_id

  identity {
    type = "SystemAssigned"
  }

  tags = local.vm_tags
}

## Azure Key Vault Access Policy for VM -  Required only if disk encryption is enabled (true) to specify the customer-managed key (CMK).
resource "azurerm_key_vault_access_policy" "des_policy" {
  count = local.cmk_encryption_enabled

  key_vault_id = data.azurerm_key_vault.import_key[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_disk_encryption_set.des[0].identity[0].principal_id

  key_permissions = ["Get", "WrapKey", "UnwrapKey"]
}

## Azure VM
resource "azurerm_windows_virtual_machine" "vm_windows" {
  count = var.windows_vm_count

  name                     = "${var.vm_name}-${count.index}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  size                     = var.vm_size
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  network_interface_ids    = [element(azurerm_network_interface.nic.*.id, count.index)]
  source_image_id          = data.azurerm_shared_image_version.image_version.id
  enable_automatic_updates = var.enable_automatic_updates
  license_type             = "Windows_Server"
  timezone                 = "Eastern Standard Time"

  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "StandardSSD_LRS"
    disk_size_gb           = var.os_disk_size
    disk_encryption_set_id = local.cmk_encryption_enabled == 1 ? azurerm_disk_encryption_set.des[0].id : null
  }
  // VM trusted launch configuration settings
  secure_boot_enabled = var.secure_boot_enabled
  vtpm_enabled        = var.vtpm_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = local.vm_tags
}

# # AAD Login Extension for Windows VM
# resource "azurerm_virtual_machine_extension" "aad_login" {
#   count = var.windows_vm_count

#   name                       = "AADLoginForWindows"
#   virtual_machine_id         = azurerm_windows_virtual_machine.vm_windows[count.index].id
#   publisher                  = "Microsoft.Azure.ActiveDirectory"
#   type                       = "AADLoginForWindows"
#   type_handler_version       = "1.0"
#   auto_upgrade_minor_version = true

#   tags = local.vm_tags
# }

# // VM's Trusted Launch configuration requires the Integrity Monitor to be installed via only from extension.
# resource "azurerm_virtual_machine_extension" "integrity_monitoring" {
#   count = var.integrity_monitoring ? var.windows_vm_count : 0

#   name                       = "GuestAttestation"
#   virtual_machine_id         = azurerm_windows_virtual_machine.vm_windows[count.index].id
#   publisher                  = "Microsoft.Azure.Security.WindowsAttestation"
#   type                       = "GuestAttestation"
#   type_handler_version       = "1.0"
#   auto_upgrade_minor_version = true
#   automatic_upgrade_enabled  = true

#   tags = local.vm_tags
# }