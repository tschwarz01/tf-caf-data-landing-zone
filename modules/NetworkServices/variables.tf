variable "environment" {
  type        = string
  description = "The release stage of the environment"
}

variable "name" {
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

variable "random" {
  type = string
}

variable "vnetAddressPrefix" {
  type        = string
  description = "Address space to use for the landing zone VNet which is peered to the connectivity hub VNet"
}

variable "servicesSubnetAddressPrefix" {
  type        = string
  description = "Address space to use for the services subnet within the landing zone VNet"
}

variable "databricksIntegrationPublicSubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the public subnet that is used for the shared integration databricks workspace."
}

variable "databricksIntegrationPrivateSubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the private subnet that is used for the shared integration databricks workspace."
}

variable "databricksProductPublicSubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the public subnet that is used for the shared product databricks workspace."
}

variable "databricksProductPrivateSubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the private subnet that is used for the shared product databricks workspace."
}

variable "powerBiGatewaySubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for the power bi gateway."
}

variable "dataIntegration001SubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for data integration 001."
}

variable "dataIntegration002SubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for data integration 002."
}

variable "dataProduct001SubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for data product 001."
}

variable "dataProduct002SubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for data product 002."
}

variable "dataManagementZoneVnetId" {
  type        = string
  description = "Specifies the resource Id of the vnet in the data management zone."
}

variable "firewallPrivateIp" {
  type        = string
  description = "Specifies the private IP address of the central firewall."
}

variable "dnsServerAdresses" {
  type        = list(string)
  description = "Specifies the private IP addresses of the dns servers."
}

/*
param location string
param prefix string
param tags object
param firewallPrivateIp string = '10.0.0.4'
param dnsServerAdresses array = [
  '10.0.0.4'
]

param dataManagementZoneVnetId string = ''

// Variables
var servicesSubnetName = 'ServicesSubnet'
var databricksIntegrationPrivateSubnetName = 'DatabricksIntegrationSubnetPrivate'
var databricksIntegrationPublicSubnetName = 'DatabricksIntegrationSubnetPublic'
var databricksProductPrivateSubnetName = 'DatabricksProductSubnetPrivate'
var databricksProductPublicSubnetName = 'DatabricksProductSubnetPublic'
var powerBiGatewaySubnetName = 'PowerBIGatewaySubnet'
var dataIntegration001SubnetName = 'DataIntegration001Subnet'
var dataIntegration002SubnetName = 'DataIntegration002Subnet'
var dataProduct001SubnetName = 'DataProduct001Subnet'
var dataProduct002SubnetName = 'DataProduct002Subnet'
var dataManagementZoneVnetSubscriptionId = length(split(dataManagementZoneVnetId, '/')) >= 9 ? split(dataManagementZoneVnetId, '/')[2] : subscription().subscriptionId
var dataManagementZoneVnetResourceGroupName = length(split(dataManagementZoneVnetId, '/')) >= 9 ? split(dataManagementZoneVnetId, '/')[4] : resourceGroup().name
var dataManagementZoneVnetName = length(split(dataManagementZoneVnetId, '/')) >= 9 ? last(split(dataManagementZoneVnetId, '/')) : 'incorrectSegmentLength'
*/
