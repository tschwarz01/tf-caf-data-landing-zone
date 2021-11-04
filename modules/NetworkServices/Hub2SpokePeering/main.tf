terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 2.65"
      configuration_aliases = [azurerm]
    }
  }
}

locals {
  dataManagementZoneVnetResourceGroupName = element(split("/", var.dataManagementZoneVnetId), 4)
  dataManagementZoneVnetName              = element(split("/", var.dataManagementZoneVnetId), length(split("/", var.dataManagementZoneVnetId)) - 1)
  dataManagementZoneVnetSubscriptionId    = element(split("/", var.dataManagementZoneVnetId), 2)
}


resource "azurerm_virtual_network_peering" "peer-hub-to-spoke" {
  name                         = "${var.name}-hub-to-spoke-peering"
  resource_group_name          = local.dataManagementZoneVnetResourceGroupName
  virtual_network_name         = local.dataManagementZoneVnetName
  remote_virtual_network_id    = var.spokeVnetId
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}
