data "azurerm_client_config" "current" {
}

locals {
  databricksIntegration001Name                   = "${var.prefix}-integration-databricks001"
  eventhubNamespaceIntegration001Name            = "${var.prefix}-integration-eventhub001"
  datafactoryIntegration001Name                  = "${var.prefix}-integration-datafactory001"
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

resource "azurerm_role_assignment" "datafactory001StorageRawRoleAssignment" {
  scope                = var.storageRawId
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.dataFactoryInt001.identity[0].principal_id
}

resource "azurerm_role_assignment" "datafactory001StorageEnrichedCuratedRoleAssignment" {
  scope                = var.storageEnrichedCuratedId
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.dataFactoryInt001.identity[0].principal_id
}

resource "azurerm_role_assignment" "datafactory001DatabricksRoleAssignment" {
  scope                = azurerm_databricks_workspace.databricksIntegration001.workspace_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.dataFactoryInt001.identity[0].principal_id
}
