output "network-output" {
  value = {
    vnetId                                 = azurerm_virtual_network.vnet.id
    nsgId                                  = azurerm_network_security_group.nsg.id
    routeTableId                           = azurerm_route_table.route_table.id
    servicesSubnetId                       = azurerm_subnet.ServicesSubnet.id
    databricksIntegrationPublicSubnetName  = azurerm_subnet.DatabricksIntegrationPublicSubnet.name
    databricksIntegrationPrivateSubnetName = azurerm_subnet.DatabricksIntegrationPrivateSubnet.name
    databricksProductPublicSubnetName      = azurerm_subnet.DatabricksProductPublicSubnet.name
    databricksProductPrivateSubnetName     = azurerm_subnet.DatabricksProductPrivateSubnet.name
  }
  description = "Output properties from the network module"
}
