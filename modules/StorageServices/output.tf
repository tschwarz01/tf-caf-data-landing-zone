output "storageRawId" {
  value = azurerm_storage_account.stgAccts["datalzrawstg"].id
}

output "storageRawFileSystemId" {
  value = azurerm_storage_data_lake_gen2_filesystem.storageFileSystemsRaw[*].id
}

output "storageEnrichedCuratedId" {
  value = azurerm_storage_account.stgAccts["datalzenrichedstg"].id
}

output "storageEnrichedCuratedFileSystemId" {
  value = azurerm_storage_data_lake_gen2_filesystem.storageFileSystemsEnriched[*].id
}

output "storageWorkspaceId" {
  value = azurerm_storage_account.stgAccts["datalzworkstg"].id
}

output "storageWorkspaceFileSystemId" {
  value = azurerm_storage_data_lake_gen2_filesystem.storageFileSystemsWork[*].id
}
