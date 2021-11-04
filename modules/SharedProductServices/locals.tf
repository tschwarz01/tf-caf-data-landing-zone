locals {
  synapseProduct001DefaultStorageAccountSubscriptionId    = element(split("/", var.synapseProduct001DefaultStorageAccountFileSystemId), 2)
  synapseProduct001DefaultStorageAccountResourceGroupName = element(split("/", var.synapseProduct001DefaultStorageAccountFileSystemId), 4)
  databricksProduct001Name                                = "${var.name}-product-databricks001"
  synapseProduct001Name                                   = "${var.name}-product-synapse001"
}
