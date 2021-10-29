output "logging-output" {
  value = {
    keyvaultId                         = azurerm_key_vault.keyVault.id
    keyVaultName                       = azurerm_key_vault.keyVault.name
    logAnalyticsWorkspaceId            = azurerm_log_analytics_workspace.logAnalytics.id
    logAnalyticsWorkspaceIdSecretName  = "${azurerm_log_analytics_workspace.logAnalytics.name}Id"
    logAnalyticsWorkspaceKeySecretName = "${azurerm_log_analytics_workspace.logAnalytics.name}Key"
  }
  description = "Output properties from the logging module"
}
