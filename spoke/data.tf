data "azurerm_subnet" "sn_ha_internal" {
  name			= "subnet-ha-internal"
  virtual_network_name	= "vnet-ha"
  resource_group_name	= var.rg_vnet_name
}

data "azurerm_subnet" "sn_spoke1" {
  name                 = "subnet-spoke1"
  virtual_network_name = "vnet-spoke1"
  resource_group_name  = var.rg_vnet_name
}

data "azurerm_subnet" "sn_spoke2" {
  name                 = "subnet-spoke2"
  virtual_network_name = "vnet-spoke2"
  resource_group_name  = var.rg_vnet_name
}
