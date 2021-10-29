
resource "azurerm_data_factory" "dataFactoryInt001" {
  name                            = local.datafactoryIntegration001Name
  location                        = var.location
  resource_group_name             = var.rgName
  public_network_enabled          = false
  tags                            = var.tags
  managed_virtual_network_enabled = true
  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_private_endpoint" "data_factory_int001_private_endpoint" {
  name                = "${var.prefix}-${azurerm_data_factory.dataFactoryInt001.name}-adf-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${azurerm_data_factory.dataFactoryInt001.name}-adf-private-endpoint-connection"
    private_connection_resource_id = azurerm_data_factory.dataFactoryInt001.id
    subresource_names              = ["dataFactory"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDataFactory]
  }
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_private_endpoint" "data_factory_int001_portal_private_endpoint" {
  name                = "${var.prefix}-${azurerm_data_factory.dataFactoryInt001.name}-adf-portal-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${azurerm_data_factory.dataFactoryInt001.name}-adf-portal-private-endpoint-connection"
    private_connection_resource_id = azurerm_data_factory.dataFactoryInt001.id
    subresource_names              = ["portal"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDataFactoryPortal]
  }
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_integration_runtime_azure" "datafactoryInt001ManagedIntegrationRuntime" {
  name                = "${var.prefix}-adf-managedIR-${azurerm_data_factory.dataFactoryInt001.name}"
  data_factory_name   = azurerm_data_factory.dataFactoryInt001.name
  resource_group_name = var.rgName
  location            = var.location
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_managed_private_endpoint" "datafactoryKeyVault001ManagedPrivateEndpoint" {
  name               = "${local.keyVault001Name}MPE"
  data_factory_id    = azurerm_data_factory.dataFactoryInt001.id
  target_resource_id = var.keyVault001Id
  subresource_name   = "vault"
}

resource "azurerm_data_factory_linked_service_key_vault" "datafactoryKeyVault001LinkedService" {
  name                     = "${local.keyVault001Name}LS"
  resource_group_name      = var.rgName
  data_factory_name        = azurerm_data_factory.dataFactoryInt001.name
  key_vault_id             = var.keyVault001Id
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.datafactoryInt001ManagedIntegrationRuntime.name
  description              = "Key Vault for storing secrets"
  additional_properties = {
    baseUrl = "https://${local.keyVault001Name}.vault.azure.net/"
  }
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.datafactoryKeyVault001ManagedPrivateEndpoint
  ]
}

resource "azurerm_data_factory_managed_private_endpoint" "datafactorySqlServer001ManagedPrivateEndpoint" {
  name               = "${local.sqlServer001Name}MPE"
  data_factory_id    = azurerm_data_factory.dataFactoryInt001.id
  target_resource_id = var.sqlServer001Id
  subresource_name   = "sqlServer"
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_linked_service_sql_server" "datafactorySqlserver001LinkedService" {
  name                     = "${local.sqlServer001Name}_${var.sqlDatabase001Name}"
  resource_group_name      = var.rgName
  data_factory_name        = azurerm_data_factory.dataFactoryInt001.name
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.datafactoryInt001ManagedIntegrationRuntime.name
  description              = "Sql Database for storing metadata"
  connection_string        = "Integrated Security=False;Encrypt=True;Connection Timeout=30;Data Source=${local.sqlServer001Name}.database.windows.net;Initial Catalog=${var.sqlDatabase001Name}"
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.datafactorySqlServer001ManagedPrivateEndpoint,
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_managed_private_endpoint" "datafactoryStorageRawManagedPrivateEndpoint" {
  name               = "${local.storageRawName}MPE"
  data_factory_id    = azurerm_data_factory.dataFactoryInt001.id
  target_resource_id = var.storageRawId
  subresource_name   = "blob"
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "datafactoryStorageRawLinkedService" {
  name                = "${local.storageRawName}_LS"
  resource_group_name = var.rgName
  data_factory_name   = azurerm_data_factory.dataFactoryInt001.name
  connection_string   = "https://${local.storageRawName}.blob.core.windows.net"
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.datafactoryStorageRawManagedPrivateEndpoint
  ]
}


resource "azurerm_data_factory_managed_private_endpoint" "datafactoryStorageEnrichedCuratedManagedPrivateEndpoint" {
  name               = "${local.storageEnrichedCuratedName}MPE"
  data_factory_id    = azurerm_data_factory.dataFactoryInt001.id
  target_resource_id = var.storageEnrichedCuratedId
  subresource_name   = "blob"
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "datafactoryStorageEnrichedCuratedLinkedService" {
  name                = "${local.storageEnrichedCuratedName}_LS"
  resource_group_name = var.rgName
  data_factory_name   = azurerm_data_factory.dataFactoryInt001.name
  connection_string   = "https://${local.storageEnrichedCuratedName}.blob.core.windows.net"
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.datafactoryStorageEnrichedCuratedManagedPrivateEndpoint
  ]
}

resource "azurerm_data_factory_linked_service_azure_databricks" "datafactoryDatabricksLinkedService" {
  name                = "${local.databricks001Name}_LS"
  data_factory_name   = azurerm_data_factory.dataFactoryInt001.name
  resource_group_name = var.rgName
  description         = "ADB Linked Service via MSI"
  adb_domain          = azurerm_databricks_workspace.databricksIntegration001.workspace_url

  msi_work_space_resource_id = azurerm_databricks_workspace.databricksIntegration001.id

  new_cluster_config {
    node_type             = "Standard_DS3_v2"
    cluster_version       = "7.3.x-scala2.12"
    min_number_of_workers = 1
    max_number_of_workers = 5
    driver_node_type      = "Standard_NC12"
    log_destination       = "dbfs:/logs"

    custom_tags = var.tags

  }
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}
