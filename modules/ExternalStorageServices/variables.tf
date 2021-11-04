variable "environment" {
  type        = string
  description = "The release stage of the environment"
  default     = "dev"
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

variable "random" {
  type = string
}
variable "rgName" {
  type        = string
  description = "The name of the resource group"
}

variable "svcSubnetId" {
  type = string
}

variable "privateDnsZoneIdBlob" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Blob Storage."
}
