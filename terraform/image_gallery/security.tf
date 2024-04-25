data "azurerm_client_config" "this" {}

# data "azuread_group" "this" {
#   display_name     = var.ad_group
#   security_enabled = true
# }

resource "azurerm_key_vault" "this" {
  name                        = "${local.team}-kv"
  resource_group_name         = data.azurerm_resource_group.this.name
  location                    = data.azurerm_resource_group.this.location
  enabled_for_disk_encryption = true
  enabled_for_deployment      = true
  tenant_id                   = data.azurerm_client_config.this.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
}

# resource "azurerm_key_vault_access_policy" "packer" {
#   key_vault_id = azurerm_key_vault.this.id
#   tenant_id    = data.azurerm_client_config.this.tenant_id
#   object_id    = data.azurerm_client_config.this.object_id

#   secret_permissions = [
#     "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
#   ]
# }

# resource "azurerm_key_vault_access_policy" "users" {
#   key_vault_id = azurerm_key_vault.this.id
#   tenant_id    = data.azurerm_client_config.this.tenant_id
#   object_id    = data.azuread_group.this.object_id

#   secret_permissions = [
#     "Get", "List"
#   ]
# }

# resource "random_password" "password" {
#   length = 16
# }

# resource "azurerm_key_vault_secret" "password" {
#   name         = "windows-password"
#   value        = random_password.password.result
#   key_vault_id = azurerm_key_vault.this.id
# }