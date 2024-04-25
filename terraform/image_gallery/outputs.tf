output "image_gallery_resource_group" {
  value = data.azurerm_resource_group.this.name
}

output "location" {
  value = data.azurerm_resource_group.this.location
}

output "shared_gallery" {
  value = azurerm_shared_image_gallery.this.name
}

output "shared_image_baseline" {
  value = [azurerm_shared_image.baseline.*.name]
}

output "shared_image_generalized" {
  value = azurerm_shared_image.generalized.name
}

output "subnet" {
  value = azurerm_subnet.this.id
}

output "key_vault" {
  value = azurerm_key_vault.this.id
}

output "secret_name" {
  value = azurerm_key_vault_secret.password.name
}