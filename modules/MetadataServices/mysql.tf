resource "azurerm_mysql_server" "mysqlServerMetadata" {
  name                = local.mySqlServer001Name
  location            = var.location
  resource_group_name = var.rgName

  administrator_login          = var.sqlAdminUserName
  administrator_login_password = var.sqlAdminPassword

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_active_directory_administrator" "mysqlServerADConfig" {
  server_name         = azurerm_mysql_server.mysqlServerMetadata.name
  resource_group_name = var.rgName
  login               = var.mysqlserverAdminGroupName
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = var.mysqlserverAdminGroupObjectID
}

resource "azurerm_mysql_configuration" "mysqlServerConfig001" {
  name                = "lower_case_table_names"
  resource_group_name = var.rgName
  server_name         = azurerm_mysql_server.mysqlServerMetadata.name
  value               = "2"
}

resource "azurerm_mysql_database" "mysqlServerHiveMetastoreDb" {
  name                = "HiveMetastoreDb"
  resource_group_name = var.rgName
  server_name         = azurerm_mysql_server.mysqlServerMetadata.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_private_endpoint" "mysqlMetadataPrivateEndpoint" {
  name                = "${var.prefix}-HiveMetastoreDb-sql-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-HiveMetastoreDb-sql-private-endpoint-connection"
    private_connection_resource_id = azurerm_mysql_server.mysqlServerMetadata.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdMySqlServer]
  }
}

resource "azurerm_key_vault_secret" "mysqlserver001UsernameSecretDeployment" {
  name         = "${local.keyVault002Name}/${local.mySqlServer001Name}Username"
  value        = var.sqlAdminUserName
  key_vault_id = azurerm_key_vault.keyVaultMetadata["datalz-vault002"].id
}

resource "azurerm_key_vault_secret" "mysqlserver001PasswordSecretDeployment" {
  name         = "${local.keyVault002Name}/${local.mySqlServer001Name}Password"
  value        = var.sqlAdminPassword
  key_vault_id = azurerm_key_vault.keyVaultMetadata["datalz-vault002"].id
}

resource "azurerm_key_vault_secret" "mysqlserver001ConnectionStringSecretDeployment" {
  name         = "${local.keyVault002Name}/${local.mySqlServer001Name}ConnectionString"
  value        = "jdbc:mysql://${local.mySqlServer001Name}.mysql.database.azure.com:3306/${azurerm_mysql_database.mysqlServerHiveMetastoreDb.name}?useSSL=true&requireSSL=false&enabledSslProtocolSuites=TLSv1.2"
  key_vault_id = azurerm_key_vault.keyVaultMetadata["datalz-vault002"].id
}
