locals {
  // Variables
  domainFileSytemNames = [
    "data",
    "di001",
    "di002"
  ]

  dataProductFileSystemNames = [
    "data",
    "dp001",
    "dp002"
  ]
}

resource "azurerm_storage_account" "stgAccts" {
  for_each                  = toset(["datalzrawstg", "datalzenrichedstg", "datalzworkstg"])
  name                      = each.key
  resource_group_name       = var.rgName
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  access_tier               = "Hot"
  is_hns_enabled            = true
  shared_access_key_enabled = true
  allow_blob_public_access  = false
  min_tls_version           = "TLS1_2"
  tags                      = var.tags
  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action = "Deny"
    bypass         = toset(["AzureServices", "Metrics"])
    ip_rules       = ["76.217.35.207"]
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "storageFileSystemsRaw" {

  for_each           = toset(local.domainFileSytemNames)
  name               = each.key
  storage_account_id = azurerm_storage_account.stgAccts["datalzrawstg"].id

}

resource "azurerm_storage_data_lake_gen2_filesystem" "storageFileSystemsEnriched" {

  for_each           = toset(local.domainFileSytemNames)
  name               = each.key
  storage_account_id = azurerm_storage_account.stgAccts["datalzenrichedstg"].id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "storageFileSystemsWork" {

  for_each           = toset(local.dataProductFileSystemNames)
  name               = each.key
  storage_account_id = azurerm_storage_account.stgAccts["datalzworkstg"].id
}


resource "azurerm_private_endpoint" "storage_blob_private_endpoint" {
  for_each            = toset(["datalzrawstg", "datalzenrichedstg", "datalzworkstg"])
  name                = "${var.prefix}-${each.key}-blob-private-endpoint"
  location            = var.location
  tags                = var.tags
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${each.key}-blob-private-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.stgAccts["${each.key}"].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdBlob]
  }
}


resource "azurerm_private_endpoint" "storage_dfs_private_endpoint" {
  for_each            = toset(["datalzrawstg", "datalzenrichedstg", "datalzworkstg"])
  name                = "${var.prefix}-${each.key}-dfs-private-endpoint"
  location            = var.location
  tags                = var.tags
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${each.key}-dfs-private-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.stgAccts["${each.key}"].id
    subresource_names              = ["dfs"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDfs]
  }
}



