resource "azurerm_key_vault" "keyVault001" {
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
    ip_rules       = ["76.217.35.207/32"]
  }
  soft_delete_retention_days = 7
  tenant_id                  = var.tenant_id
}

resource "azurerm_key_vault" "keyVault002" {
  name                            = local.keyVault002Name
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
    ip_rules       = ["76.217.35.207/32"]
  }
  soft_delete_retention_days = 7
  tenant_id                  = var.tenant_id
}

# KeyVault Private Link
resource "azurerm_private_endpoint" "keyvault001_private_endpoint" {
  name                = "${var.name}-${azurerm_key_vault.keyVault001.name}-keyvault001-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_key_vault.keyVault001.name}-keyvault001-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.keyVault001.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdKeyVault]
  }
}

# KeyVault Private Link
resource "azurerm_private_endpoint" "keyvault002_private_endpoint" {
  name                = "${var.name}-${azurerm_key_vault.keyVault002.name}-keyvault002-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_key_vault.keyVault002.name}-keyvault002-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.keyVault002.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdKeyVault]
  }
}
