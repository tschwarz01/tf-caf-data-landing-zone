
resource "azurerm_route_table" "route_table" {
  name                          = "${var.prefix}-routetable"
  location                      = var.location
  resource_group_name           = var.rgName
  disable_bgp_route_propagation = false

  route {
    name                   = "to-firewall-default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewallPrivateIp
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association_services" {
  subnet_id      = azurerm_subnet.ServicesSubnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}

resource "azurerm_subnet_route_table_association" "route_table_association_dbricksIntPub" {
  subnet_id      = azurerm_subnet.DatabricksIntegrationPublicSubnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}

resource "azurerm_subnet_route_table_association" "route_table_association_dbricksIntPri" {
  subnet_id      = azurerm_subnet.DatabricksIntegrationPrivateSubnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}

resource "azurerm_subnet_route_table_association" "route_table_association_dbricksPrdPub" {
  subnet_id      = azurerm_subnet.DatabricksProductPublicSubnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}

resource "azurerm_subnet_route_table_association" "route_table_association_dbricksPrdPri" {
  subnet_id      = azurerm_subnet.DatabricksProductPrivateSubnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}

resource "azurerm_subnet_route_table_association" "route_table_association_PbiGW" {
  subnet_id      = azurerm_subnet.PowerBIGatewaySubnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}

resource "azurerm_subnet_route_table_association" "route_table_association_dataInt001" {
  subnet_id      = azurerm_subnet.DataIntegration001Subnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}
resource "azurerm_subnet_route_table_association" "route_table_association_dataInt002" {
  subnet_id      = azurerm_subnet.DataIntegration002Subnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}
resource "azurerm_subnet_route_table_association" "route_table_association_dataPrd001" {
  subnet_id      = azurerm_subnet.DataProduct001Subnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}
resource "azurerm_subnet_route_table_association" "route_table_association_dataPrd002" {
  subnet_id      = azurerm_subnet.DataProduct002Subnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route_table
  ]
}
