locals {
  dataManagementZoneVnetResourceGroupName = element(split("/", var.dataManagementZoneVnetId), 4)
  dataManagementZoneVnetName              = element(split("/", var.dataManagementZoneVnetId), length(split("/", var.dataManagementZoneVnetId)) - 1)
  dataManagementZoneVnetSubscriptionId    = element(split("/", var.dataManagementZoneVnetId), 2)
  subnet_delegation_actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
}
