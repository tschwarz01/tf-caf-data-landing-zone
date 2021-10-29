locals {
  dataManagementZoneVnetResourceGroupName = element(split("/", var.dataManagementZoneVnetId), 4)
  dataManagementZoneVnetName              = element(split("/", var.dataManagementZoneVnetId), length(split("/", var.dataManagementZoneVnetId)) - 1)
  dataManagementZoneVnetSubscriptionId    = element(split("/", var.dataManagementZoneVnetId), 2)
}
