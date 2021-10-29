
resource "azurerm_key_vault" "keyVault" {
  name                            = local.keyVault001Name
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
resource "azurerm_private_endpoint" "keyvault_private_endpoint" {
  name                = "${var.prefix}-${azurerm_key_vault.keyVault.name}-keyvault-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${azurerm_key_vault.keyVault.name}-keyvault-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.keyVault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdKeyVault]
  }
}


