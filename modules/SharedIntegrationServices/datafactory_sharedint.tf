
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
  name                = "${var.name}-${azurerm_data_factory.dataFactoryInt001.name}-adf-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_data_factory.dataFactoryInt001.name}-adf-private-endpoint-connection"
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
  name                = "${var.name}-${azurerm_data_factory.dataFactoryInt001.name}-adf-portal-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_data_factory.dataFactoryInt001.name}-adf-portal-pe-conn"
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

resource "azurerm_role_assignment" "datafactory001StorageRawRoleAssignment" {
  scope                = var.storageRawId
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.dataFactoryInt001.identity[0].principal_id
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_role_assignment" "datafactory001StorageEnrichedCuratedRoleAssignment" {
  scope                = var.storageEnrichedCuratedId
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.dataFactoryInt001.identity[0].principal_id
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_role_assignment" "datafactory001DatabricksRoleAssignment" {
  scope                = azurerm_databricks_workspace.databricksIntegration001.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.dataFactoryInt001.identity[0].principal_id
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_integration_runtime_azure" "datafactoryInt001ManagedIntegrationRuntime" {
  name                = "${var.name}-adf-managedIR-${azurerm_data_factory.dataFactoryInt001.name}"
  data_factory_name   = azurerm_data_factory.dataFactoryInt001.name
  resource_group_name = var.rgName
  location            = var.location
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_managed_private_endpoint" "datafactoryKeyVault001ManagedPrivateEndpoint" {
  name               = "KeyVault001MPE"
  data_factory_id    = azurerm_data_factory.dataFactoryInt001.id
  target_resource_id = var.keyVault001Id
  subresource_name   = "vault"
}

resource "azurerm_data_factory_linked_service_key_vault" "datafactoryKeyVault001LinkedService" {
  name                     = "KeyVault001LS"
  resource_group_name      = var.rgName
  data_factory_name        = azurerm_data_factory.dataFactoryInt001.name
  key_vault_id             = var.keyVault001Id
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.datafactoryInt001ManagedIntegrationRuntime.name
  description              = "Key Vault for storing secrets"
  additional_properties = {
    baseUrl = "https://${var.keyVault001Name}.vault.azure.net/"
  }
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.datafactoryKeyVault001ManagedPrivateEndpoint
  ]
}

resource "azurerm_data_factory_managed_private_endpoint" "datafactorySqlServer001ManagedPrivateEndpoint" {
  name               = "sqlServer001MPE"
  data_factory_id    = azurerm_data_factory.dataFactoryInt001.id
  target_resource_id = var.sqlServer001Id
  subresource_name   = "sqlServer"
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_linked_service_sql_server" "datafactorySqlserver001LinkedService" {
  name                     = "sqlServer001_${var.sqlDatabase001Name}"
  resource_group_name      = var.rgName
  data_factory_name        = azurerm_data_factory.dataFactoryInt001.name
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.datafactoryInt001ManagedIntegrationRuntime.name
  description              = "Sql Database for storing metadata"
  connection_string        = "Integrated Security=False;Encrypt=True;Connection Timeout=30;Data Source=${var.sqlServer001Name}.database.windows.net;Initial Catalog=${var.sqlDatabase001Name}"
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.datafactorySqlServer001ManagedPrivateEndpoint,
    azurerm_data_factory.dataFactoryInt001
  ]
}

/*
resource "azurerm_data_factory_managed_private_endpoint" "datafactoryStorageRawBlobManagedPrivateEndpoint" {
  name               = "storage001MPE"
  data_factory_id    = azurerm_data_factory.dataFactoryInt001.id
  target_resource_id = var.storageRawId
  subresource_name   = "blob"
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}
*/

resource "azurerm_data_factory_managed_private_endpoint" "datafactoryStorageRawDfsManagedPrivateEndpoint" {
  name               = "${var.storageRawName}DFS_MPE"
  data_factory_id    = azurerm_data_factory.dataFactoryInt001.id
  target_resource_id = var.storageRawId
  subresource_name   = "dfs"
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "datafactoryStorageRawDfsLinkedService" {
  name                 = "${var.storageRawName}DFS_LS"
  resource_group_name  = var.rgName
  data_factory_name    = azurerm_data_factory.dataFactoryInt001.name
  use_managed_identity = true
  url                  = "https://${var.storageRawName}.dfs.core.windows.net"
  depends_on = [
    azurerm_data_factory.dataFactoryInt001,
    azurerm_data_factory_managed_private_endpoint.datafactoryStorageRawDfsManagedPrivateEndpoint,
    azurerm_role_assignment.datafactory001StorageRawRoleAssignment
  ]
}
/*
resource "azurerm_data_factory_linked_service_azure_blob_storage" "datafactoryStorageRawLinkedService" {
  name                = "storage001BlobLS"
  resource_group_name = var.rgName
  data_factory_name   = azurerm_data_factory.dataFactoryInt001.name
  connection_string   = "https://${var.storageRawName}.blob.core.windows.net"
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.datafactoryStorageRawBlobManagedPrivateEndpoint
  ]
}
*/

resource "azurerm_data_factory_managed_private_endpoint" "datafactoryStorageDFSEnrichedCuratedManagedPrivateEndpoint" {
  name               = "${var.storageEnrichedCuratedName}DFS_MPE"
  data_factory_id    = azurerm_data_factory.dataFactoryInt001.id
  target_resource_id = var.storageEnrichedCuratedId
  subresource_name   = "dfs"
  depends_on = [
    azurerm_data_factory.dataFactoryInt001
  ]
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "datafactoryStorageDFSEnrichedCuratedLinkedService" {
  name                 = "${var.storageEnrichedCuratedName}DFS_LS"
  resource_group_name  = var.rgName
  data_factory_name    = azurerm_data_factory.dataFactoryInt001.name
  use_managed_identity = true
  url                  = "https://${var.storageEnrichedCuratedName}.dfs.core.windows.net"
  depends_on = [
    azurerm_data_factory.dataFactoryInt001,
    azurerm_data_factory_managed_private_endpoint.datafactoryStorageDFSEnrichedCuratedManagedPrivateEndpoint,
    azurerm_role_assignment.datafactory001StorageEnrichedCuratedRoleAssignment
  ]
}

/*
resource "azurerm_data_factory_linked_service_azure_blob_storage" "datafactoryStorageEnrichedCuratedLinkedService" {
  name                = "${var.storageEnrichedCuratedName}_LS"
  resource_group_name = var.rgName
  data_factory_name   = azurerm_data_factory.dataFactoryInt001.name
  connection_string   = "https://${var.storageEnrichedCuratedName}.blob.core.windows.net"
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.datafactoryStorageDFSEnrichedCuratedManagedPrivateEndpoint
  ]
}
*/

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
