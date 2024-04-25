# data "azurerm_key_vault_secret" "password" {
#   name         = var.secret_name
#   key_vault_id = var.key_vault
# }

module "virtualmachine" {
  source = "../modules/compute"

  shared_image_gallery_name         = var.shared_gallery
  resource_group_name               = var.resource_group != null ? var.resource_group : var.image_gallery_resource_group
  image_gallery_resource_group_name = var.image_gallery_resource_group
  location                          = var.location
  # shared_image_name                 = var.shared_image
  shared_image_name                 = var.shared_image_generalized
  subnet_ids                        = [var.subnet]
  vm_name                           = var.vm_name
  vm_size                           = var.vm_size
  windows_vm_count                  = var.vm_count
  admin_username                    = var.windows_username
  admin_password                    = "DummyPass$5896"
  # admin_password                    = data.azurerm_key_vault_secret.password.value
}