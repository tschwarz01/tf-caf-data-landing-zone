locals {
  keyVault001Name             = "${var.name}-vault01-${var.random}"
  logAnalytics001Name         = "${var.name}-lz01-${var.random}"
  keyVaultPrivateEndpointName = "${azurerm_key_vault.keyVault.name}-private-endpoint"
}
