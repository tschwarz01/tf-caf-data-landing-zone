output "storage-services-output" {
  value = {

    storageRawId                       = azurerm_storage_account.stgAccts["datalzrawstg"].id
    storageRawName                     = azurerm_storage_account.stgAccts["datalzrawstg"].name
    storageRawFileSystemId             = azurerm_storage_data_lake_gen2_filesystem.storageFileSystemsRaw["data"].id
    storageEnrichedCuratedId           = azurerm_storage_account.stgAccts["datalzenrichedstg"].id
    storageEnrichedCuratedName         = azurerm_storage_account.stgAccts["datalzenrichedstg"].name
    storageEnrichedCuratedFileSystemId = azurerm_storage_data_lake_gen2_filesystem.storageFileSystemsEnriched["data"].id
    storageWorkspaceId                 = azurerm_storage_account.stgAccts["datalzworkstg"].id
    storageWorkspaceFileSystemId       = azurerm_storage_data_lake_gen2_filesystem.storageFileSystemsWork["data"].id
  }
}
