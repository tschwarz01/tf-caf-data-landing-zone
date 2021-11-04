resource "azurerm_eventhub_namespace" "eventhubNamespaceIntegration001" {
  name                     = local.eventhubNamespaceIntegration001Name
  location                 = var.location
  resource_group_name      = var.rgName
  sku                      = "Standard"
  maximum_throughput_units = 20
  zone_redundant           = true
  auto_inflate_enabled     = true

  tags = {
    environment = "Production"
  }
  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_private_endpoint" "event_hub_int001_private_endpoint" {
  name                = "${var.name}-${azurerm_eventhub_namespace.eventhubNamespaceIntegration001.name}-ehn-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_eventhub_namespace.eventhubNamespaceIntegration001.name}-ehn-private-endpoint-connection"
    private_connection_resource_id = azurerm_eventhub_namespace.eventhubNamespaceIntegration001.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdEventhubNamespace]
  }
}
