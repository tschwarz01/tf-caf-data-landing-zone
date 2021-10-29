
variable "environment" {
  type        = string
  description = "The release stage of the environment"
}

variable "prefix" {
  type        = string
  description = "prefix to be used for resource names"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "tags" {
  type        = map(string)
  description = "Tags that should be applied to all deployed resources"
}

variable "rgName" {
  type        = string
  description = "The name of the resource group"
}

variable "svcSubnetId" {
  type = string
}

variable "privateDnsZoneIdKeyVault" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Key Vault."
}
