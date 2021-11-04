output "metadata-services-output" {
  value = {
    sqlServer001Id                           = azurerm_mssql_server.sqlServerMetadata.id
    sqlServer001Name                         = azurerm_mssql_server.sqlServerMetadata.name
    sqlServer001DatabaseName                 = azurerm_mssql_database.sqlDatabaseMetadata.name
    mySqlServer001Id                         = azurerm_mysql_database.mysqlServerHiveMetastoreDb.name
    keyVault001Id                            = azurerm_key_vault.keyVault001.id
    keyVault001Name                          = azurerm_key_vault.keyVault001.name
    mySqlServer001UsernameSecretName         = "${local.mySqlServer001Name}Username"
    mySqlServer001PasswordSecretName         = "${local.mySqlServer001Name}Password"
    mySqlServer001ConnectionStringSecretName = "${local.mySqlServer001Name}ConnectionString"
  }

}
