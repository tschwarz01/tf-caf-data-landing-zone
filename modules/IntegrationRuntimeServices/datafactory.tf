
locals {

  artifactstorage001Name     = "${var.prefix}artfctstg001"
  datafactoryRuntimes001Name = "${var.prefix}-runtime-datafactory001"
  shir001Name                = "${var.prefix}-shir001"
  shir002Name                = "${var.prefix}-shir002"
  vmssName                   = local.shir001Name
  loadbalancerName           = "${local.vmssName}-lb"
  fileUri                    = "https://raw.githubusercontent.com/Azure/data-landing-zone/main/code/installSHIRGateway.ps1"
  dataFactoryName            = azurerm_data_factory.dataFactory.name
}

module "shir001" {
  count           = var.create_shir ? 1 : 0
  source          = "./shir"
  dataFactoryName = azurerm_data_factory.dataFactory.name
  vmssName        = local.shir001Name
  location        = var.location
  prefix          = var.prefix
  random          = var.random
  tags            = var.tags
  rgName          = var.rgName
  svcSubnetId     = var.svcSubnetId
  vmAdminUserName = var.vmAdminUserName
  vmAdminPassword = var.vmAdminPassword
  depends_on = [
    azurerm_data_factory.dataFactory
  ]
}

resource "azurerm_data_factory" "dataFactory" {
  name                            = local.datafactoryRuntimes001Name
  location                        = var.location
  resource_group_name             = var.rgName
  public_network_enabled          = false
  tags                            = var.tags
  managed_virtual_network_enabled = true
  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_private_endpoint" "data_factory_private_endpoint" {
  name                = "${var.prefix}-${azurerm_data_factory.dataFactory.name}-adf-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${azurerm_data_factory.dataFactory.name}-adf-private-endpoint-connection"
    private_connection_resource_id = azurerm_data_factory.dataFactory.id
    subresource_names              = ["dataFactory"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDataFactory]
  }
}

resource "azurerm_private_endpoint" "data_factory_portal_private_endpoint" {
  name                = "${var.prefix}-${azurerm_data_factory.dataFactory.name}-adf-portal-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${azurerm_data_factory.dataFactory.name}-adf-portal-private-endpoint-connection"
    private_connection_resource_id = azurerm_data_factory.dataFactory.id
    subresource_names              = ["portal"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDataFactoryPortal]
  }
}


resource "azurerm_data_factory_integration_runtime_azure" "datafactoryManagedIntegrationRuntime001" {
  name                = "${var.prefix}-adf-managedIR-${azurerm_data_factory.dataFactory.name}"
  data_factory_name   = azurerm_data_factory.dataFactory.name
  resource_group_name = var.rgName
  location            = var.location
}

