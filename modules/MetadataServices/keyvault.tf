resource "azurerm_key_vault" "keyVaultMetadata" {
  for_each                        = toset(local.keyVaults)
  name                            = each.key
  location                        = var.location
  resource_group_name             = var.rgName
  sku_name                        = "standard"
  enabled_for_disk_encryption     = false
  enabled_for_deployment          = false
  purge_protection_enabled        = true
  enable_rbac_authorization       = true
  enabled_for_template_deployment = false
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
  soft_delete_retention_days = 7
  tenant_id                  = data.azurerm_client_config.current.tenant_id
}


# KeyVault Private Link
resource "azurerm_private_endpoint" "keyvaultMetadata_private_endpoint" {
  for_each            = toset(local.keyVaults)
  name                = "${var.prefix}-${azurerm_key_vault.keyVaultMetadata[each.key].name}-keyvaultMetadata-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${azurerm_key_vault.keyVaultMetadata[each.key].name}-keyvaultMetadata-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.keyVaultMetadata["${each.key}"].id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdKeyVault]
  }
}
