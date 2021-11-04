output "datafactoryIntegration001Id" {
  value = azurerm_data_factory.dataFactoryInt001.id
}

output "databricksIntegration001Id" {
  value = azurerm_databricks_workspace.databricksIntegration001.workspace_id
}

output "databricksIntegration001ApiUrl" {
  value = "https://${var.location}.azuredatabricks.net"
}

output "shared-integration-services-output" {
  value = {
    datafactoryIntegration001Id    = azurerm_data_factory.dataFactoryInt001.id
    databricksIntegration001Id     = azurerm_databricks_workspace.databricksIntegration001.workspace_id
    databricksIntegration001ApiUrl = "https://${var.location}.azuredatabricks.net"
  }
}
