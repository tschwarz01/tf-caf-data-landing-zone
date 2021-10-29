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

variable "rgName" {
  type        = string
  description = "The name of the resource group"
}

variable "privateDnsZoneIdDataFactory" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Data Factory."
}

variable "privateDnsZoneIdDataFactoryPortal" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for the Data Factory Portal."
}



variable "vmAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Virtual Machines created by this deployment"
}

variable "vmAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Virtual Machines created by this deployment"
}


variable "deploySelfHostedIntegrationRuntimes" {
  type        = bool
  description = "Specifies whether the self-hosted integration runtimes should be deployed. This only works, if the pwsh script was uploded and is available."
  default     = false
}

variable "datafactoryIds" {
  type        = list(string)
  description = "List of Data Factory resource IDs that should be associated with the shared integration runtime"
}

variable "portalDeployment" {
  type = bool
}

variable "svcSubnetId" {
  type = string
}
