
# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  backend "azurerm" {
    subscription_id      = "47f7e6d7-0e52-4394-92cb-5f106bbc647f"
    tenant_id            = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    resource_group_name  = "rg-data-management-zone-terraform"
    storage_account_name = "stgdatamgmtzoneterraform"
    container_name       = "tfstatedatalz"
    key                  = "tfstatedatalz.tfstate"
    use_azuread_auth     = true
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "random_string" "random" {
  length  = 4
  number  = true
  special = false
  lower   = true
  upper   = false
}

resource "azurerm_resource_group" "rg_networking" {
  name     = "rg-${local.name}-network"
  location = var.location
  tags     = var.tags
}

module "networkServices" {
  source                                          = "./modules/NetworkServices"
  environment                                     = var.environment
  location                                        = var.location
  name                                            = local.name
  tags                                            = var.tags
  random                                          = random_string.random.result
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

module "remotePeering" {
  source                   = "./modules/NetworkServices/Hub2SpokePeering"
  name                     = local.name
  spokeVnetId              = module.networkServices.network-output.vnetId
  dataManagementZoneVnetId = var.dataManagementZoneVnetId
  providers = {
    azurerm = azurerm.datamz
  }
  depends_on = [
    module.networkServices
  ]
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
  tenant_id                = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
  name                     = local.name
  tags                     = var.tags
  random                   = random_string.random.result
  rgName                   = azurerm_resource_group.rg_logging.name
  svcSubnetId              = module.networkServices.network-output.servicesSubnetId
  privateDnsZoneIdKeyVault = var.privateDnsZoneIdKeyVault
  depends_on = [
    module.networkServices
  ]
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
  random                              = random_string.random.result
  vmAdminUserName                     = var.vmAdminUserName
  vmAdminPassword                     = var.vmAdminPassword
  svcSubnetId                         = module.networkServices.network-output.servicesSubnetId
  privateDnsZoneIdDataFactory         = var.privateDnsZoneIdDataFactory
  privateDnsZoneIdDataFactoryPortal   = var.privateDnsZoneIdDataFactoryPortal
  deploySelfHostedIntegrationRuntimes = var.deploySelfHostedIntegrationRuntimes
  datafactoryIds                      = var.datafactoryIds
  portalDeployment                    = true
  create_shir                         = var.deploySelfHostedIntegrationRuntimes
  depends_on = [
    module.networkServices
  ]
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
  random               = random_string.random.result
  svcSubnetId          = module.networkServices.network-output.servicesSubnetId
  privateDnsZoneIdBlob = var.privateDnsZoneIdBlob
  privateDnsZoneIdDfs  = var.privateDnsZoneIdDfs
  depends_on = [
    module.networkServices
  ]
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
  random               = random_string.random.result
  svcSubnetId          = module.networkServices.network-output.servicesSubnetId
  privateDnsZoneIdBlob = var.privateDnsZoneIdBlob
  depends_on = [
    module.networkServices
  ]
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
  name                          = local.name
  tags                          = var.tags
  tenant_id                     = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
  random                        = random_string.random.result
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
  depends_on = [
    module.networkServices
  ]
}

resource "azurerm_resource_group" "rg_shared_integration" {
  name     = "rg-${local.name}-shared-integration"
  location = var.location
  tags     = var.tags
}

module "sharedIntegrationServices" {
  source                                    = "./modules/SharedIntegrationServices"
  location                                  = var.location
  name                                      = local.name
  tags                                      = var.tags
  random                                    = random_string.random.result
  rgName                                    = azurerm_resource_group.rg_shared_integration.name
  svcSubnetId                               = module.networkServices.network-output.servicesSubnetId
  vnetId                                    = module.networkServices.network-output.vnetId
  databricksIntegration001PrivateSubnetName = module.networkServices.network-output.databricksIntegrationPrivateSubnetName
  databricksIntegrationPrivateNsgAssocId    = module.networkServices.network-output.databricksIntegrationPrivateNsgAssocId
  databricksIntegration001PublicSubnetName  = module.networkServices.network-output.databricksIntegrationPublicSubnetName
  databricksIntegrationPublicNsgAssocId     = module.networkServices.network-output.databricksIntegrationPublicNsgAssocId
  storageRawId                              = module.storageServices.storage-services-output.storageRawId
  storageRawName                            = module.storageServices.storage-services-output.storageRawName
  storageAccountRawFileSystemId             = module.storageServices.storage-services-output.storageRawFileSystemId
  storageEnrichedCuratedId                  = module.storageServices.storage-services-output.storageEnrichedCuratedId
  storageEnrichedCuratedName                = module.storageServices.storage-services-output.storageEnrichedCuratedName
  storageAccountEnrichedCuratedFileSystemId = module.storageServices.storage-services-output.storageEnrichedCuratedFileSystemId
  keyVault001Id                             = module.metadataServices.metadata-services-output.keyVault001Id
  keyVault001Name                           = module.metadataServices.metadata-services-output.keyVault001Name
  sqlServer001Id                            = module.metadataServices.metadata-services-output.sqlServer001Id
  sqlServer001Name                          = module.metadataServices.metadata-services-output.sqlServer001Name
  sqlDatabase001Name                        = module.metadataServices.metadata-services-output.sqlServer001DatabaseName
  privateDnsZoneIdDataFactory               = var.privateDnsZoneIdDataFactory
  privateDnsZoneIdDataFactoryPortal         = var.privateDnsZoneIdDataFactory
  privateDnsZoneIdEventhubNamespace         = var.privateDnsZoneIdEventhubNamespace
  storageServicesResourceGroupName          = azurerm_resource_group.rg_storage.name
  create_shir                               = var.deploySelfHostedIntegrationRuntimes
  depends_on = [
    module.networkServices,
    module.storageServices,
    module.metadataServices
  ]
}

resource "azurerm_resource_group" "rg_shared_product" {
  name     = "rg-${local.name}-shared-product"
  location = var.location
  tags     = var.tags
}

module "sharedProductServices" {
  source                                             = "./modules/SharedProductServices"
  location                                           = var.location
  name                                               = local.name
  tags                                               = var.tags
  random                                             = random_string.random.result
  rgName                                             = azurerm_resource_group.rg_shared_product.name
  svcSubnetId                                        = module.networkServices.network-output.servicesSubnetId
  vnetId                                             = module.networkServices.network-output.vnetId
  tenant_id                                          = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
  databricksProduct001PrivateSubnetName              = module.networkServices.network-output.databricksProductPrivateSubnetName
  databricksProduct001PublicSubnetName               = module.networkServices.network-output.databricksProductPublicSubnetName
  databricksIntegrationPrivateNsgAssocId             = module.networkServices.network-output.databricksIntegrationPrivateNsgAssocId
  databricksIntegrationPublicNsgAssocId              = module.networkServices.network-output.databricksIntegrationPublicNsgAssocId
  vmAdminUserName                                    = var.vmAdminUserName
  vmAdminPassword                                    = var.vmAdminPassword
  synapseProduct001DefaultStorageAccountId           = module.storageServices.storage-services-output.storageWorkspaceId
  synapseProduct001DefaultStorageAccountFileSystemId = module.storageServices.storage-services-output.storageWorkspaceFileSystemId
  synapseSqlAdminGroupName                           = var.sqlserverAdminGroupName
  synapseSqlAdminGroupObjectID                       = var.sqlserverAdminGroupObjectID
  sqlAdminPassword                                   = var.sqlAdminPassword
  sqlAdminUserName                                   = var.sqlAdminUserName
  synapseProduct001ComputeSubnetId                   = ""
  privateDnsZoneIdSynapseDev                         = var.privateDnsZoneIdSynapseDev
  privateDnsZoneIdSynapseSql                         = var.privateDnsZoneIdSynapseSql
  depends_on = [
    module.networkServices,
    module.storageServices
  ]
}

/*
resource "azurerm_role_assignment" "synapse001StorageRoleAssignment" {
  scope                = module.storageServices.storage-services-output.storageWorkspaceId
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.sharedProductServices.shared-product-output.synapseMsi
  skip_service_principal_aad_check = true

  depends_on = [
    module.sharedProductServices
  ]
}
*/

// The following resource groups are pre-deployed with this base landing zone template
// They are intended to be used by the supplemental templates which are
// available for "Data Product Analytics", "Data Product Batch" and
// "Data Product Streaming" workloads

resource "azurerm_resource_group" "rg_data_integration001" {
  name     = "rg-${local.name}-data-int001"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_data_integration002" {
  name     = "rg-${local.name}-data-int002"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_data_product001" {
  name     = "rg-${local.name}-data-product001"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_data_product002" {
  name     = "rg-${local.name}-data-product002"
  location = var.location
  tags     = var.tags
}

/*
// Data integration resources 001
resource dataIntegration001ResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${name}-di001'
  location: location
  tags: tagsJoined
  properties: {}
}

resource dataIntegration002ResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${name}-di002'
  location: location
  tags: tagsJoined
  properties: {}
}

// Data product resources 001
resource dataProduct001ResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${name}-dp001'
  location: location
  tags: tagsJoined
  properties: {}
}

resource dataProduct002ResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${name}-dp002'
  location: location
  tags: tagsJoined
  properties: {}
}
*/
