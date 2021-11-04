output "loggingServicesOutput" {
  value = module.loggingServices.logging-output
}

output "networkServicesOutput" {
  value = module.networkServices.network-output
}

output "storageServicesOutput" {
  value = module.storageServices.storage-services-output
}

output "sharedProductServicesOutput" {
  value = module.sharedProductServices.shared-product-output
}

output "sharedIntegrationServicesOutput" {
  value = module.sharedIntegrationServices.shared-integration-services-output
}

output "integrationRuntimeServicesOutput" {
  value = module.runtimeServices.runtimes-output
}

output "metadataServicesOutput" {
  value = module.metadataServices.metadata-services-output
}
