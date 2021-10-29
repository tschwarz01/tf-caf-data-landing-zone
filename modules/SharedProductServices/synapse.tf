resource "azurerm_synapse_workspace" "synapseProduct001" {
  name                                 = local.synapseProduct001Name
  resource_group_name                  = var.rgName
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.synapseProduct001DefaultStorageAccountFileSystemId
  sql_administrator_login              = var.sqlAdminUserName
  sql_administrator_login_password     = var.sqlAdminPassword
  sql_identity_control_enabled         = true
  managed_virtual_network_enabled      = true

  aad_admin {
    login     = var.synapseSqlAdminGroupName
    object_id = var.synapseSqlAdminGroupObjectID
    tenant_id = data.azurerm_client_config.current.tenant_id
  }
  tags = var.tags
}





resource "azurerm_private_endpoint" "synapsePrivateEndpointSql" {
  name                = "${var.prefix}-synapse001-sql-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-synapse001-sql-private-endpoint-connection"
    private_connection_resource_id = azurerm_synapse_workspace.synapseProduct001.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdSynapseSql]
  }
}

resource "azurerm_private_endpoint" "synapsePrivateEndpointSqlOnDemand" {
  name                = "${var.prefix}-synapse001-sqlod-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-synapse001-sqlod-private-endpoint-connection"
    private_connection_resource_id = azurerm_synapse_workspace.synapseProduct001.id
    subresource_names              = ["SqlOnDemand"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdSynapseSql]
  }
}

resource "azurerm_private_endpoint" "synapsePrivateEndpointDev" {
  name                = "${var.prefix}-synapse001-dev-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-synapse001-dev-private-endpoint-connection"
    private_connection_resource_id = azurerm_synapse_workspace.synapseProduct001.id
    subresource_names              = ["Dev"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdSynapseDev]
  }
}
