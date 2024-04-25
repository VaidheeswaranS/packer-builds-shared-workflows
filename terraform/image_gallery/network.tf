locals {
  centralhub = {
    rg        = "Central-Hub-DevTestLab-RG"
    vnet_name = "central-hub-devtestlab-vnet"
  }
}

data "azurerm_virtual_network" "centralhub_vnet" {
  provider = azurerm.centralhub

  name                = local.centralhub.vnet_name
  resource_group_name = local.centralhub.rg
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.shared_gallery}-vnet"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  address_space       = [var.vnet_cidr]
}

resource "azurerm_network_security_group" "this" {
  name                = "inbound-access"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
}

resource "azurerm_network_security_rule" "this" {
  name                        = "inbound-rdp"
  network_security_group_name = azurerm_network_security_group.this.name
  resource_group_name         = data.azurerm_resource_group.this.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet" "this" {
  name                 = "primary"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.vnet_cidr]
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_virtual_network_peering" "to_centralhub" {
  name                         = "${azurerm_virtual_network.this.name}-to-centralhub"
  resource_group_name          = data.azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = data.azurerm_virtual_network.centralhub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "to_this" {
  provider = azurerm.centralhub

  name                         = "${azurerm_virtual_network.this.name}-to-centralhub"
  resource_group_name          = local.centralhub.rg
  virtual_network_name         = local.centralhub.vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.this.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}