locals {
  keyVault001Name    = "datalz-metaVault01-${var.random}"
  keyVault002Name    = "datalz-metaVault02-${var.random}"
  sqlServer001Name   = "${var.name}-sqlserver-${var.random}"
  mySqlServer001Name = "${var.name}-mysqlserver-${var.random}"

  keyVaults = [local.keyVault001Name, local.keyVault002Name]
}
