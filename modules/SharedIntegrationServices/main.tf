data "azurerm_client_config" "current" {
}

locals {
  databricksIntegration001Name                   = "${var.name}-integration-databricks001"
  eventhubNamespaceIntegration001Name            = "${var.name}-integration-eventhub001"
  datafactoryIntegration001Name                  = "${var.name}-integration-datafactory001"
  storageAccountRawSubscriptionId                = data.azurerm_client_config.current.subscription_id
  storageAccountRawResourceGroupName             = var.storageServicesResourceGroupName
  storageAccountEnrichedCuratedSubscriptionId    = data.azurerm_client_config.current.subscription_id
  storageAccountEnrichedCuratedResourceGroupName = var.storageServicesResourceGroupName

  databricks001Name                                   = azurerm_databricks_workspace.databricksIntegration001.name
  storageRawName                                      = element(split("/", var.storageRawId), length(split("/", var.storageRawId)) - 1)
  storageEnrichedCuratedName                          = element(split("/", var.storageEnrichedCuratedId), length(split("/", var.storageEnrichedCuratedId)) - 1)
  keyVault001Name                                     = element(split("/", var.keyVault001Id), length(split("/", var.keyVault001Id)) - 1)
  sqlServer001Name                                    = element(split("/", var.sqlServer001Id), length(split("/", var.sqlServer001Id)) - 1)
  datafactoryDefaultManagedVnetIntegrationRuntimeName = "AutoResolveIntegrationRuntime"
  datafactoryPrivateEndpointNameDatafactory           = "dataFactoryInt001-datafactory-private-endpoint"
  datafactoryPrivateEndpointNamePortal                = "dataFactoryInt001-portal-private-endpoint"
}


