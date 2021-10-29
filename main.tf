
# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-data-management-zone-terraform"
    storage_account_name = "stgdatamgmtzoneterraform"
    container_name       = "tfstatedatalz"
    key                  = "tfstatedatalz.tfstate"
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg_networking" {
  name     = "rg-${local.name}-network"
  location = var.location
  tags     = var.tags
}

module "networkServices" {
  source                                          = "./modules/NetworkServices"
  environment                                     = var.environment
  location                                        = var.location
  prefix                                          = var.prefix
  tags                                            = var.tags
  rgName                                          = azurerm_resource_group.rg_networking.name
  vnetAddressPrefix                               = var.vnetAddressPrefix
  servicesSubnetAddressPrefix                     = var.servicesSubnetAddressPrefix
  databricksIntegrationPublicSubnetAddressPrefix  = var.databricksIntegrationPublicSubnetAddressPrefix
  databricksIntegrationPrivateSubnetAddressPrefix = var.databricksIntegrationPrivateSubnetAddressPrefix
  databricksProductPublicSubnetAddressPrefix      = var.databricksProductPublicSubnetAddressPrefix
  databricksProductPrivateSubnetAddressPrefix     = var.databricksProductPrivateSubnetAddressPrefix
  powerBiGatewaySubnetAddressPrefix               = var.powerBiGatewaySubnetAddressPrefix
  dataIntegration001SubnetAddressPrefix           = var.dataIntegration001SubnetAddressPrefix
  dataIntegration002SubnetAddressPrefix           = var.dataIntegration002SubnetAddressPrefix
  dataProduct001SubnetAddressPrefix               = var.dataProduct001SubnetAddressPrefix
  dataProduct002SubnetAddressPrefix               = var.dataProduct002SubnetAddressPrefix
  dataManagementZoneVnetId                        = var.dataManagementZoneVnetId
  firewallPrivateIp                               = var.firewallPrivateIp
  dnsServerAdresses                               = var.dnsServerAdresses
}

resource "azurerm_resource_group" "rg_management" {
  name     = "rg-${local.name}-mgmt"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_logging" {
  name     = "rg-${local.name}-logging"
  location = var.location
  tags     = var.tags
}

module "loggingServices" {
  source                   = "./modules/LoggingServices"
  location                 = var.location
  environment              = var.environment
  prefix                   = var.prefix
  tags                     = var.tags
  rgName                   = azurerm_resource_group.rg_logging.name
  svcSubnetId              = module.networkServices.network-output.servicesSubnetId
  privateDnsZoneIdKeyVault = var.privateDnsZoneIdKeyVault
}

resource "azurerm_resource_group" "rg_runtimes" {
  name     = "rg-${local.name}-runtimes"
  location = var.location
  tags     = var.tags
}

module "runtimeServices" {
  source                              = "./modules/IntegrationRuntimeServices"
  rgName                              = azurerm_resource_group.rg_runtimes.name
  location                            = var.location
  prefix                              = var.prefix
  tags                                = var.tags
  vmAdminUserName                     = var.vmAdminUserName
  vmAdminPassword                     = var.vmAdminPassword
  svcSubnetId                         = module.networkServices.network-output.servicesSubnetId
  privateDnsZoneIdDataFactory         = var.privateDnsZoneIdDataFactory
  privateDnsZoneIdDataFactoryPortal   = var.privateDnsZoneIdDataFactoryPortal
  deploySelfHostedIntegrationRuntimes = var.deploySelfHostedIntegrationRuntimes
  datafactoryIds                      = var.datafactoryIds
  portalDeployment                    = true

}

resource "azurerm_resource_group" "rg_storage" {
  name     = "rg-${local.name}-storage"
  location = var.location
  tags     = var.tags
}

module "storageServices" {
  source               = "./modules/StorageServices"
  rgName               = azurerm_resource_group.rg_storage.name
  location             = var.location
  prefix               = var.prefix
  tags                 = var.tags
  svcSubnetId          = module.networkServices.network-output.servicesSubnetId
  privateDnsZoneIdBlob = var.privateDnsZoneIdBlob
  privateDnsZoneIdDfs  = var.privateDnsZoneIdDfs

}

resource "azurerm_resource_group" "rg_storage-external" {
  name     = "rg-${local.name}-externalstorage"
  location = var.location
  tags     = var.tags
}

module "externalStorageServices" {
  source               = "./modules/ExternalStorageServices"
  location             = var.location
  rgName               = azurerm_resource_group.rg_storage-external.name
  prefix               = var.prefix
  tags                 = var.tags
  svcSubnetId          = module.networkServices.network-output.servicesSubnetId
  privateDnsZoneIdBlob = var.privateDnsZoneIdBlob
}

resource "azurerm_resource_group" "rg_metadata" {
  name     = "rg-${local.name}-metadata"
  location = var.location
  tags     = var.tags
}

module "metadataServices" {
  source                        = "./modules/MetadataServices"
  location                      = var.location
  rgName                        = azurerm_resource_group.rg_metadata.name
  prefix                        = var.prefix
  tags                          = var.tags
  svcSubnetId                   = module.networkServices.network-output.servicesSubnetId
  vmAdminUserName               = var.vmAdminUserName
  vmAdminPassword               = var.vmAdminPassword
  sqlserverAdminGroupName       = var.sqlserverAdminGroupName
  sqlserverAdminGroupObjectID   = var.sqlserverAdminGroupObjectID
  sqlAdminUserName              = var.sqlAdminUserName
  sqlAdminPassword              = var.sqlAdminPassword
  mysqlserverAdminGroupName     = var.mysqlserverAdminGroupName
  mysqlserverAdminGroupObjectID = var.mysqlserverAdminGroupObjectID
  privateDnsZoneIdKeyVault      = var.privateDnsZoneIdKeyVault
  privateDnsZoneIdSqlServer     = var.privateDnsZoneIdSqlServer
  privateDnsZoneIdMySqlServer   = var.privateDnsZoneIdMySqlServer
}

resource "azurerm_resource_group" "rg_shared_integration" {
  name     = "rg-${local.name}-shared-integration"
  location = var.location
  tags     = var.tags
}

module "sharedIntegrationServices" {
  source                                    = "./modules/SharedIntegrationServices"
  location                                  = var.location
  prefix                                    = var.prefix
  tags                                      = var.tags
  rgName                                    = azurerm_resource_group.rg_shared_integration.name
  svcSubnetId                               = module.networkServices.network-output.servicesSubnetId
  vnetId                                    = module.networkServices.network-output.vnetId
  databricksIntegration001PrivateSubnetName = module.networkServices.network-output.databricksIntegration001PrivateSubnetName
  databricksIntegration001PublicSubnetName  = module.networkServices.network-output.databricksIntegration001PublicSubnetName
  storageRawId                              = module.storageServices.storageRawId
  storageAccountRawFileSystemId             = module.storageServices.storageRawFileSystemId
  storageEnrichedCuratedId                  = module.storageServices.storageEnrichedCuratedId
  storageAccountEnrichedCuratedFileSystemId = module.storageServices.storageEnrichedCuratedFileSystemId
  keyVault001Id                             = module.metadataServices.keyVault001Id
  sqlServer001Id                            = module.metadataServices.sqlServer001Id
  sqlDatabase001Name                        = module.metadataServices.sqlServer001DatabaseName
  privateDnsZoneIdDataFactory               = var.privateDnsZoneIdDataFactory
  privateDnsZoneIdDataFactoryPortal         = var.privateDnsZoneIdDataFactory
  privateDnsZoneIdEventhubNamespace         = var.privateDnsZoneIdEventhubNamespace
  storageServicesResourceGroupName          = azurerm_resource_group.rg_storage.name
}

resource "azurerm_resource_group" "rg_shared_product" {
  name     = "rg-${local.name}-shared-product"
  location = var.location
  tags     = var.tags
}

module "sharedProductServices" {
  source                                             = "./modules/SharedProductServices"
  location                                           = var.location
  prefix                                             = var.prefix
  tags                                               = var.tags
  rgName                                             = azurerm_resource_group.rg_shared_product.name
  svcSubnetId                                        = module.networkServices.network-output.servicesSubnetId
  vnetId                                             = module.networkServices.network-output.vnetId
  databricksProduct001PrivateSubnetName              = module.networkServices.network-output.databricksProduct001PrivateSubnetName
  databricksProduct001PublicSubnetName               = module.networkServices.network-output.databricksProduct001PublicSubnetName
  vmAdminUserName                                    = var.vmAdminUserName
  vmAdminPassword                                    = var.vmAdminPassword
  synapseProduct001DefaultStorageAccountId           = module.storageServices.storageWorkspaceId
  synapseProduct001DefaultStorageAccountFileSystemId = module.storageServices.storageWorkspaceFileSystemId
  synapseSqlAdminGroupName                           = var.sqlserverAdminGroupName
  synapseSqlAdminGroupObjectID                       = var.sqlserverAdminGroupObjectID
  sqlAdminPassword                                   = var.sqlAdminPassword
  sqlAdminUserName                                   = var.sqlAdminUserName
  synapseProduct001ComputeSubnetId                   = ""
  privateDnsZoneIdSynapseDev                         = var.privateDnsZoneIdSynapseDev
  privateDnsZoneIdSynapseSql                         = var.privateDnsZoneIdSynapseSql
}
