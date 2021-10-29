
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

variable "vmAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Virtual Machines created by this deployment"
}

variable "vmAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Virtual Machines created by this deployment"
}

variable "sqlserverAdminGroupName" {
  type        = string
  description = "AD Group for Azure SQL sysadmin access"
}

variable "sqlserverAdminGroupObjectID" {
  type        = string
  description = "AD Group ObjectID for Azure SQL sysadmin access"
}

variable "sqlAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Azure SQL Databases created by this deployment"
}

variable "sqlAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Azure SQL Databases created by this deployment"
}

variable "mysqlserverAdminGroupName" {
  type        = string
  description = "AD Group for Azure MySQL sysadmin access"
}

variable "mysqlserverAdminGroupObjectID" {
  type        = string
  description = "AD Group ObjectID for Azure MySQL admin access"
}

variable "privateDnsZoneIdSqlServer" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure SQL DB."
}

variable "privateDnsZoneIdMySqlServer" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Database for MySQL."
}
