resource "azurerm_storage_account" "externalStorage" {
  name                      = "${var.prefix}ext001"
  resource_group_name       = var.rgName
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  access_tier               = "Hot"
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
  }

}

resource "azurerm_storage_container" "externalStorageContainer" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.externalStorage.name
  container_access_type = "private"
}


resource "azurerm_private_endpoint" "storageext_blob_private_endpoint" {
  name                = "${var.prefix}-ext-blob-private-endpoint"
  location            = var.location
  tags                = var.tags
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-ext-blob-private-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.externalStorage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdBlob]
  }
}
