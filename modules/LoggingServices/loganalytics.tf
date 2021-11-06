resource "azurerm_log_analytics_workspace" "logAnalytics" {
  name                       = local.logAnalytics001Name
  location                   = var.location
  resource_group_name        = var.rgName
  sku                        = "PerGB2018"
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  retention_in_days          = 120
  tags                       = var.tags
}

resource "azurerm_key_vault_secret" "logAnalytics001IdSecretDeployment" {
  name         = "${azurerm_log_analytics_workspace.logAnalytics.name}1Id"
  value        = azurerm_log_analytics_workspace.logAnalytics.workspace_id
  content_type = "text/plain"
  key_vault_id = azurerm_key_vault.keyVault.id
  depends_on = [
    azurerm_key_vault.keyVault
  ]
}

resource "azurerm_key_vault_secret" "logAnalytics001KeySecretDeployment" {
  name         = "${azurerm_log_analytics_workspace.logAnalytics.name}1Key"
  value        = azurerm_log_analytics_workspace.logAnalytics.primary_shared_key
  content_type = "text/plain"
  key_vault_id = azurerm_key_vault.keyVault.id
  depends_on = [
    azurerm_key_vault.keyVault
  ]
}
