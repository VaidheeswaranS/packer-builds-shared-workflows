data "azurerm_resource_group" "this" {
  name = var.rg
}

locals {
  team = join("-", slice(split("_", var.shared_gallery), 0, 2))
}

resource "azurerm_shared_image_gallery" "this" {
  name                = var.shared_gallery
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
}

resource "random_id" "baseline" {
  prefix      = "2022-datacenter-"
  byte_length = 8
}

resource "azurerm_shared_image" "baseline" {
  # count                    = var.image_definition_baseline == "cloudops-shared-baseline-windows2022" ? 1 : 0
  count                    = var.image_definition_baseline == "vaidhee-shared-baseline-windows2022" ? 1 : 0
  name                     = var.image_definition_baseline
  gallery_name             = azurerm_shared_image_gallery.this.name
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  os_type                  = "Windows"
  architecture             = "x64"
  hyper_v_generation       = "V2"
  trusted_launch_supported = true

  identifier {
    publisher = "Microsoft"
    offer     = "WindowsServer"
    sku       = random_id.baseline.hex
  }
}

resource "random_id" "generalized" {
  prefix      = "2022-datacenter-"
  byte_length = 8
}

resource "azurerm_shared_image" "generalized" {
  name                     = var.image_definition_generalized
  gallery_name             = azurerm_shared_image_gallery.this.name
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  os_type                  = "Windows"
  architecture             = "x64"
  hyper_v_generation       = "V2"
  trusted_launch_supported = true

  identifier {
    publisher = "Microsoft"
    offer     = "WindowsServer"
    sku       = random_id.generalized.hex
  }
}