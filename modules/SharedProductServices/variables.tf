variable "privateDnsZoneIdSynapseSql" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Synapse Sql Namespaces."
}

variable "privateDnsZoneIdSynapseDev" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Synapse Dev Namespaces."
}

variable "prefix" {
  type        = string
  description = "prefix to be used for resource names"
  default     = "datalz"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "southcentralus"
}

variable "tags" {
  type        = map(string)
  description = "Tags that should be applied to all deployed resources"
  default = {
    deployedBy = "terraform/azure/caf-enterprise-scale/v1.0.0"
    Owner      = ""
    Project    = ""
    #Environment = locals.environment
    Toolkit = "Terraform"
  }
}

variable "rgName" {
  type        = string
  description = "The name of the resource group"
}

variable "svcSubnetId" {
  type = string
}

variable "vnetId" {
  type = string
}

variable "databricksProduct001PrivateSubnetName" {
  type = string
}

variable "databricksProduct001PublicSubnetName" {
  type = string
}

variable "vmAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Virtual Machines created by this deployment"
}

variable "vmAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Virtual Machines created by this deployment"
}

variable "synapseProduct001DefaultStorageAccountFileSystemId" {
  type = string
}

variable "synapseProduct001DefaultStorageAccountId" {
  type = string
}

variable "synapseSqlAdminGroupName" {
  type        = string
  description = "AD Group for Azure Synapse SQL sysadmin access"
}

variable "synapseSqlAdminGroupObjectID" {
  type        = string
  description = "AD Group ObjectID for Azure Synapse SQL sysadmin access"
}

variable "sqlAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Azure SQL Databases created by this deployment"
}

variable "sqlAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Azure SQL Databases created by this deployment"
}

variable "synapseProduct001ComputeSubnetId" {
  type = string
}
