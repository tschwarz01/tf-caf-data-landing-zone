
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}-network"
  address_space       = [var.vnetAddressPrefix]
  location            = var.location
  resource_group_name = var.rgName
  dns_servers         = var.dnsServerAdresses

}

resource "azurerm_subnet" "ServicesSubnet" {
  name                                           = "${var.name}-subnet-servicessubnet"
  address_prefixes                               = [var.servicesSubnetAddressPrefix]
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = var.rgName
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}

resource "azurerm_subnet" "DatabricksIntegrationPublicSubnet" {
  name                 = "${var.name}-subnet-dbricksintegrationpub"
  address_prefixes     = [var.databricksIntegrationPublicSubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      actions = local.subnet_delegation_actions
      name    = "Microsoft.Databricks/workspaces"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "DatabricksIntegrationPrivateSubnet" {
  name                 = "${var.name}-subnet-dbricksintegrationpri"
  address_prefixes     = [var.databricksIntegrationPrivateSubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      actions = local.subnet_delegation_actions
      name    = "Microsoft.Databricks/workspaces"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "DatabricksProductPublicSubnet" {
  name                 = "${var.name}-subnet-dbricksproductpub"
  address_prefixes     = [var.databricksProductPublicSubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      actions = local.subnet_delegation_actions
      name    = "Microsoft.Databricks/workspaces"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "DatabricksProductPrivateSubnet" {
  name                 = "${var.name}-subnet-dbricksproductpri"
  address_prefixes     = [var.databricksProductPrivateSubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "DatabricksSubnetDelegation"
    service_delegation {
      actions = local.subnet_delegation_actions
      name    = "Microsoft.Databricks/workspaces"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "PowerBIGatewaySubnet" {
  name                 = "${var.name}-subnet-pbigwsubnet"
  address_prefixes     = [var.powerBiGatewaySubnetAddressPrefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rgName
  delegation {
    name = "PowerBIGatewaySubnetDelegation"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.PowerPlatform/vnetaccesslinks"
    }
  }
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet" "DataIntegration001Subnet" {
  name                                           = "${var.name}-subnet-dataint01"
  address_prefixes                               = [var.dataIntegration001SubnetAddressPrefix]
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = var.rgName
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}
resource "azurerm_subnet" "DataIntegration002Subnet" {
  name                                           = "${var.name}-subnet-dataint02"
  address_prefixes                               = [var.dataIntegration002SubnetAddressPrefix]
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = var.rgName
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}
resource "azurerm_subnet" "DataProduct001Subnet" {
  name                                           = "${var.name}-subnet-dataproduct01"
  address_prefixes                               = [var.dataProduct001SubnetAddressPrefix]
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = var.rgName
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}
resource "azurerm_subnet" "DataProduct002Subnet" {
  name                                           = "${var.name}-subnet-dataproduct02"
  address_prefixes                               = [var.dataProduct002SubnetAddressPrefix]
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = var.rgName
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}

resource "azurerm_virtual_network_peering" "peer-spoke-to-hub" {
  name                         = "${var.name}-spoke-to-hub-peering"
  resource_group_name          = var.rgName
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = var.dataManagementZoneVnetId
  use_remote_gateways          = true
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

