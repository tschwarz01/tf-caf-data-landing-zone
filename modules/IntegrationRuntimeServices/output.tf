output "runtimes-output" {
  value = {
    artiactStorageAccountId             = azurerm_storage_account.artifactsStorage.id
    artifactStorageAccountContainerName = azurerm_storage_container.artifactstorageScriptsContainer.name
    dataFactoryId                       = azurerm_data_factory.dataFactory.id
    dataFactoryMSI                      = module.shir001[0].dataFactoryMSI
  }
  description = "Output properties from the runtimes module"
}
