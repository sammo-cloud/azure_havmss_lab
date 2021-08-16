resource "azurerm_resource_group" "rg_vnet" {
  name     = var.rg_vnet_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet_mgmt" {
  name                = "vnet-mgmt"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  address_space       = ["10.255.0.0/16"]
}

resource "azurerm_virtual_network" "vnet_vmss" {
  name                = "vnet-vmss"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  address_space       = [cidrsubnet(var.lab_cidr,7,50)]
}

resource "azurerm_virtual_network" "vnet_ha" {
  name                = "vnet-ha"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  address_space       = [cidrsubnet(var.lab_cidr,7,100)]
}

resource "azurerm_virtual_network" "vnet_spoke1" {
  name                = "vnet-spoke1"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  address_space       = [cidrsubnet(var.lab_cidr,7,0)]
}

resource "azurerm_virtual_network" "vnet_spoke2" {
  name                = "vnet-spoke2"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  address_space       = [cidrsubnet(var.lab_cidr,7,1)]
}

resource "azurerm_subnet" "sn_mgmt" {
  name                 = "subnet-mgmt"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet_mgmt.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.vnet_mgmt.address_space[0], 8, 255)
}

resource "azurerm_subnet" "sn_spoke1" {
  name                 = "subnet-spoke1"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke1.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.vnet_spoke1.address_space[0], 1, 0)
}


resource "azurerm_subnet" "sn_spoke2" {
  name                 = "subnet-spoke2"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke2.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.vnet_spoke2.address_space[0], 1, 0)
}

resource "azurerm_subnet" "sn_vmss_external" {
  name                 = "subnet-vmss-external"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet_vmss.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.vnet_vmss.address_space[0], 1, 0)
}

resource "azurerm_subnet" "sn_vmss_internal" {
  name                 = "subnet-vmss-internal"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet_vmss.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.vnet_vmss.address_space[0], 1, 1)
}

resource "azurerm_subnet" "sn_ha_external" {
  name                 = "subnet-ha-external"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet_ha.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.vnet_ha.address_space[0], 1, 0)
}

resource "azurerm_subnet" "sn_ha_internal" {
  name                 = "subnet-ha-internal"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet_ha.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.vnet_ha.address_space[0], 1, 1)
}
