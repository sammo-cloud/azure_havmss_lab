resource "azurerm_virtual_network_peering" "pr_vnetmgmttoha" {
  name                      = "mgmttoha"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet_mgmt.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_ha.id
}

resource "azurerm_virtual_network_peering" "pr_vnethatomgmt" {
  name                      = "mgmttoha"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet_ha.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_mgmt.id
}

resource "azurerm_virtual_network_peering" "pr_vnetmgmttovmss" {
  name                      = "mgmttovmss"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet_mgmt.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_vmss.id
}

resource "azurerm_virtual_network_peering" "pr_vnetvmsstomgmt" {
  name                      = "mgmttovmss"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet_vmss.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_mgmt.id
}

resource "azurerm_virtual_network_peering" "pr_vnetspoke1tovmss" {
  name                      = "spoke1tovmss"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet_spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_vmss.id
}

resource "azurerm_virtual_network_peering" "pr_vnetvmsstospoke1" {
  name                      = "spoke1tovmss"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet_vmss.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_spoke1.id
}

resource "azurerm_virtual_network_peering" "pr_vnetspoke1toha" {
  name                      = "spoke1toha"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet_spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_ha.id
}

resource "azurerm_virtual_network_peering" "pr_vnethatospoke1" {
  name                      = "spoke1toha"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet_ha.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_spoke1.id
}
