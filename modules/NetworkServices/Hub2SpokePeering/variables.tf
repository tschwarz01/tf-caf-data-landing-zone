variable "name" {
  type        = string
  description = "prefix to be used for resource names"
}

variable "dataManagementZoneVnetId" {
  type        = string
  description = "Specifies the resource Id of the vnet in the data management zone."
}

variable "spokeVnetId" {
  type        = string
  description = "VNet ID of the landing zone spoke virtual network"
}
