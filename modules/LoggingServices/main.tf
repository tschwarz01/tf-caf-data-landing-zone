resource "random_string" "random" {
  length  = 5
  number  = true
  special = false
  lower   = true
  upper   = false
}


/*
// Outputs
output logAnalytics001WorkspaceKeyVaultId string = keyVault001.outputs.keyvaultId
output logAnalytics001WorkspaceIdSecretName string = logAnalytics001SecretDeployment.outputs.logAnalyticsWorkspaceIdSecretName
output logAnalytics001WorkspaceKeySecretName string = logAnalytics001SecretDeployment.outputs.logAnalyticsWorkspaceKeySecretName
output keyvaultId string = keyVault.id
output keyVaultName string = keyVault.name
*/
