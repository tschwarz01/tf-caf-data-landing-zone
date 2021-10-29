data "azurerm_client_config" "current" {}

locals {
  keyVault001Name             = "${var.prefix}-vault003"
  logAnalytics001Name         = "${var.prefix}-la001"
  keyVaultPrivateEndpointName = "${azurerm_key_vault.keyVault.name}-private-endpoint"
}



/*
// Outputs
output logAnalytics001WorkspaceKeyVaultId string = keyVault001.outputs.keyvaultId
output logAnalytics001WorkspaceIdSecretName string = logAnalytics001SecretDeployment.outputs.logAnalyticsWorkspaceIdSecretName
output logAnalytics001WorkspaceKeySecretName string = logAnalytics001SecretDeployment.outputs.logAnalyticsWorkspaceKeySecretName
output keyvaultId string = keyVault.id
output keyVaultName string = keyVault.name
*/
