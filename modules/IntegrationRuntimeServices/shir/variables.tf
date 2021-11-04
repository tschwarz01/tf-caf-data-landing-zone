
variable "svcSubnetId" {
  type = string
}

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
    deployedBy = ""
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

variable "dataFactoryName" {
  type = string
}

variable "vmssName" {
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
