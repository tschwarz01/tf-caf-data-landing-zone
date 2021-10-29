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

variable "storageServicesResourceGroupName" {
  type = string
}

variable "storageRawId" {
  type = string
}

variable "storageAccountRawFileSystemId" {
  type = string
}

variable "storageEnrichedCuratedId" {
  type = string
}

variable "storageAccountEnrichedCuratedFileSystemId" {
  type = string
}

variable "keyVault001Id" {
  type = string
}

variable "sqlServer001Id" {
  type = string
}

variable "sqlDatabase001Name" {
  type = string
}

variable "privateDnsZoneIdDataFactory" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Data Factory."
}

variable "privateDnsZoneIdDataFactoryPortal" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for the Data Factory Portal."
}

variable "privateDnsZoneIdEventhubNamespace" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Event Hub Namespaces."
}

variable "databricksIntegration001PrivateSubnetName" {
  type = string
}

variable "databricksIntegration001PublicSubnetName" {
  type = string
}

