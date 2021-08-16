resource "time_sleep" "wait" {
  depends_on = [azurerm_virtual_machine_scale_set.vmss_spoke1]

  create_duration = "180s"
}

resource "azurerm_route_table" "rt_spoke1" {
  depends_on = [time_sleep.wait]
  name                          = "RT-spoke1"
  location                      = var.location
  resource_group_name           = var.rg_vnet_name
  disable_bgp_route_propagation = false
}

resource "azurerm_route" "r_spoke1_tointernet" {
  name                = "R-ToInternet"
  resource_group_name = var.rg_vnet_name
  route_table_name    = azurerm_route_table.rt_spoke1.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = cidrhost(data.azurerm_subnet.sn_ha_internal.address_prefix, 5)
}

resource "azurerm_route" "r_spoke1_tolocal" {
  name                = "R-ToLocal"
  resource_group_name = var.rg_vnet_name
  route_table_name    = azurerm_route_table.rt_spoke1.name
  address_prefix      = "10.0.0.0/8"
  next_hop_type              = "vnetlocal"
}

resource "azurerm_subnet_route_table_association" "rta_spoke1" {
  subnet_id      = data.azurerm_subnet.sn_spoke1.id
  route_table_id = azurerm_route_table.rt_spoke1.id
}
