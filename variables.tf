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

variable "vnetAddressPrefix" {
  type        = string
  description = "Address space to use for the landing zone VNet which is peered to the connectivity hub VNet"
  default     = "10.1.0.0/16"
}

variable "servicesSubnetAddressPrefix" {
  type        = string
  description = "Address space to use for the services subnet within the landing zone VNet"
  default     = "10.1.0.0/24"
}

variable "databricksIntegrationPublicSubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the public subnet that is used for the shared integration databricks workspace."
  default     = "10.1.1.0/24"
}

variable "databricksIntegrationPrivateSubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the private subnet that is used for the shared integration databricks workspace."
  default     = "10.1.2.0/24"
}

variable "databricksProductPublicSubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the public subnet that is used for the shared product databricks workspace."
  default     = "10.1.3.0/24"
}

variable "databricksProductPrivateSubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the private subnet that is used for the shared product databricks workspace."
  default     = "10.1.4.0/24"
}

variable "powerBiGatewaySubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for the power bi gateway."
  default     = "10.1.5.0/24"
}

variable "dataIntegration001SubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for data integration 001."
  default     = "10.1.6.0/24"
}

variable "dataIntegration002SubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for data integration 002."
  default     = "10.1.7.0/24"
}

variable "dataProduct001SubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for data product 001."
  default     = "10.1.8.0/24"
}

variable "dataProduct002SubnetAddressPrefix" {
  type        = string
  description = "Specifies the address space of the subnet that is used for data product 002."
  default     = "10.1.9.0/24"
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

variable "vmAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Virtual Machines created by this deployment"
}

variable "vmAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Virtual Machines created by this deployment"
}

variable "sqlAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Azure SQL Databases created by this deployment"
}

variable "sqlAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Azure SQL Databases created by this deployment"
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

variable "sqlserverAdminGroupName" {
  type        = string
  description = "AD Group for Azure SQL sysadmin access"
}

variable "sqlserverAdminGroupObjectID" {
  type        = string
  description = "AD Group ObjectID for Azure SQL sysadmin access"
}

variable "mysqlserverAdminGroupName" {
  type        = string
  description = "AD Group for Azure MySQL sysadmin access"
}

variable "mysqlserverAdminGroupObjectID" {
  type        = string
  description = "AD Group ObjectID for Azure MySQL admin access"
}
variable "privateDnsZoneIdKeyVault" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Key Vault."
}

variable "privateDnsZoneIdDataFactory" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Data Factory."
}

variable "privateDnsZoneIdDataFactoryPortal" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for the Data Factory Portal."
}

variable "privateDnsZoneIdDfs" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Datalake Storage."
}

variable "privateDnsZoneIdBlob" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Blob Storage."
}

variable "privateDnsZoneIdSqlServer" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure SQL DB."
}

variable "privateDnsZoneIdMySqlServer" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Database for MySQL."
}

variable "privateDnsZoneIdEventhubNamespace" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Event Hub Namespaces."
}

variable "privateDnsZoneIdSynapseSql" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Synapse Sql Namespaces."
}

variable "privateDnsZoneIdSynapseDev" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Synapse Dev Namespaces."
}
