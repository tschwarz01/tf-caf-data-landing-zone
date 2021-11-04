resource "azurerm_role_assignment" "synapse001StorageRoleAssignment" {
  scope                            = var.synapseProduct001DefaultStorageAccountId
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = azurerm_synapse_workspace.synapseProduct001.identity[0].principal_id
  skip_service_principal_aad_check = true

  depends_on = [
    azurerm_synapse_workspace.synapseProduct001,
    azurerm_synapse_sql_pool.synapseSqlPool001,
    azurerm_synapse_spark_pool.synapseSparkPool001
  ]
}
