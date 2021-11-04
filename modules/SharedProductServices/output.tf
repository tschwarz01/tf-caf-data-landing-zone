output "shared-product-output" {
  value = {
    synapseProduct001Id              = azurerm_synapse_workspace.synapseProduct001.id
    databricksProduct001Id           = azurerm_databricks_workspace.databricksProduct001.id
    databricksProduct001ApiUrl       = "https://${var.location}.azuredatabricks.net"
    databricksProduct001WorkspaceUrl = azurerm_databricks_workspace.databricksProduct001.workspace_url
    synapseMsi                       = azurerm_synapse_workspace.synapseProduct001.identity[0].principal_id
  }
  description = "Output properties from the Shared Products module"
}
