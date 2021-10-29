output "datafactoryIntegration001Id" {
  value = azurerm_data_factory.dataFactoryInt001.id
}

output "databricksIntegration001Id" {
  value = azurerm_databricks_workspace.databricksIntegration001.workspace_id
}

output "databricksIntegration001ApiUrl" {
  value = "https://${var.location}.azuredatabricks.net"
}
