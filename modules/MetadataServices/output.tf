output "sqlServer001Id" {
  value = azurerm_mssql_server.sqlServerMetadata.id
}

output "sqlServer001DatabaseName" {
  value = azurerm_mssql_database.sqlDatabaseMetadata.name
}
output "mySqlServer001Id" {
  value = azurerm_mysql_server.mysqlServerMetadata.id
}

output "mySqlServerDatabaseName" {
  value = azurerm_mysql_database.mysqlServerHiveMetastoreDb.name
}

output "keyVault001Id" {
  value = azurerm_key_vault.keyVaultMetadata["${local.keyVault001Name}"].id
}

output "mySqlServer001UsernameSecretName" {
  value = "${local.mySqlServer001Name}Username"
}

output "mySqlServer001PasswordSecretName" {
  value = "${local.mySqlServer001Name}Password"
}

output "mySqlServer001ConnectionStringSecretName" {
  value = "${local.mySqlServer001Name}ConnectionString"
}
