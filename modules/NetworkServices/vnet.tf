
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-network"
  address_space       = [var.vnetAddressPrefix]
  location            = var.location
  resource_group_name = var.rgName
  dns_servers         = var.dnsServerAdresses

}

resource "azurerm_subnet" "ServicesSubnet" {
  name                 = "${var.prefix}-subnet-servicessubnet"
  address_prefixes     = [var.servicesSubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
}

resource "azurerm_subnet" "DatabricksIntegrationPublicSubnet" {
  name                 = "${var.prefix}-subnet-dbricksintegrationpub"
  address_prefixes     = [var.databricksIntegrationPublicSubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "DatabricksIntegrationPrivateSubnet" {
  name                 = "${var.prefix}-subnet-dbricksintegrationpri"
  address_prefixes     = [var.databricksIntegrationPrivateSubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "DatabricksProductPublicSubnet" {
  name                 = "${var.prefix}-subnet-dbricksproductpub"
  address_prefixes     = [var.databricksProductPublicSubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "DatabricksProductPrivateSubnet" {
  name                 = "${var.prefix}-subnet-dbricksproductpri"
  address_prefixes     = [var.databricksProductPrivateSubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "PowerBIGatewaySubnet" {
  name                 = "${var.prefix}-subnet-pbigwsubnet"
  address_prefixes     = [var.powerBiGatewaySubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "PowerBIGatewaySubnetDelegation"
    service_delegation {
      name = "Microsoft.PowerPlatform/vnetaccesslinks"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "DataIntegration001Subnet" {
  name                                           = "${var.prefix}-subnet-dataint01"
  address_prefixes                               = [var.dataIntegration001SubnetAddressPrefix]
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = var.rgName
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}
resource "azurerm_subnet" "DataIntegration002Subnet" {
  name                                           = "${var.prefix}-subnet-dataint02"
  address_prefixes                               = [var.dataIntegration002SubnetAddressPrefix]
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = var.rgName
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}
resource "azurerm_subnet" "DataProduct001Subnet" {
  name                                           = "${var.prefix}-subnet-dataproduct01"
  address_prefixes                               = [var.dataProduct001SubnetAddressPrefix]
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = var.rgName
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}
resource "azurerm_subnet" "DataProduct002Subnet" {
  name                                           = "${var.prefix}-subnet-dataproduct02"
  address_prefixes                               = [var.dataProduct002SubnetAddressPrefix]
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = var.rgName
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}

resource "azurerm_virtual_network_peering" "peer-spoke-to-hub" {
  name                         = "${var.prefix}-spoke-to-hub-peering"
  resource_group_name          = var.rgName
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = var.dataManagementZoneVnetId
  use_remote_gateways          = true
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "peer-hub-to-spoke" {
  name                         = "${var.prefix}-hub-to-spoke-peering"
  resource_group_name          = local.dataManagementZoneVnetResourceGroupName
  virtual_network_name         = local.dataManagementZoneVnetName
  remote_virtual_network_id    = azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}
