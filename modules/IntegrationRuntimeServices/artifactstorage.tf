resource "azurerm_storage_account" "artifactsStorage" {
  name                      = local.artifactstorage001Name
  resource_group_name       = var.rgName
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  access_tier               = "Hot"
  shared_access_key_enabled = true
  allow_blob_public_access  = false
  min_tls_version           = "TLS1_2"

  network_rules {
    default_action = "Allow"
    bypass         = toset(["AzureServices"])
  }

  tags = var.tags
}


resource "azurerm_storage_container" "artifactstorageScriptsContainer" {
  name                  = "scripts"
  storage_account_name  = azurerm_storage_account.artifactsStorage.name
  container_access_type = "private"
}
