/*
module synapse001StorageRoleAssignment 'auxiliary/synapseRoleAssignmentStorage.bicep' = {
  name: 'synapse001StorageRoleAssignment'
  scope: resourceGroup(synapseProduct001DefaultStorageAccountSubscriptionId, synapseProduct001DefaultStorageAccountResourceGroupName)
  params: {
    storageAccountFileSystemId: synapseProduct001DefaultStorageAccountFileSystemId
    synapseId: synapseProduct001.outputs.synapseId
  }
}
*/

locals {
  synapseProduct001DefaultStorageAccountSubscriptionId    = element(split("/", var.synapseProduct001DefaultStorageAccountFileSystemId), 2)
  synapseProduct001DefaultStorageAccountResourceGroupName = element(split("/", var.synapseProduct001DefaultStorageAccountFileSystemId), 4)
  databricksProduct001Name                                = "${var.prefix}-product-databricks001"
  synapseProduct001Name                                   = "${var.prefix}-product-synapse001"
}
data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "synapse001StorageRoleAssignment" {
  scope                = var.synapseProduct001DefaultStorageAccountId
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.synapseProduct001.id
  depends_on = [
    azurerm_synapse_workspace.synapseProduct001
  ]
}


