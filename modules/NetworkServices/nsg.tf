resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}-default-nsg"
  location            = var.location
  resource_group_name = var.rgName

  tags = var.tags
}


resource "azurerm_network_security_group" "databricks-nsg" {
  name                = "${var.name}-databricks-nsg"
  location            = var.location
  resource_group_name = var.rgName

  /*
  security_rule = [{
    name                                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound"
    description                                = "Required for worker nodes communication within a cluster."
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_address_prefix                      = "VirtualNetwork"
    source_port_range                          = "*"
    destination_port_range                     = "*"
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_ranges                    = []
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_ranges                         = []
    },
    {
      name                                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound"
      description                                = "Required for worker nodes communication within a cluster."
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "VirtualNetwork"
      destination_address_prefix                 = "VirtualNetwork"
      access                                     = "Allow"
      priority                                   = 101
      direction                                  = "Outbound"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_ranges                    = []
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_ranges                         = []
    },
    {
      name                                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql"
      description                                = "Required for workers communication with Azure SQL services."
      protocol                                   = "tcp"
      source_port_range                          = "*"
      destination_port_range                     = "3306"
      source_address_prefix                      = "VirtualNetwork"
      destination_address_prefix                 = "Sql"
      access                                     = "Allow"
      priority                                   = 102
      direction                                  = "Outbound"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_ranges                    = []
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_ranges                         = []
    },
    {
      name                                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage"
      description                                = "Required for workers communication with Azure Storage services."
      protocol                                   = "tcp"
      source_port_range                          = "*"
      destination_port_range                     = "443"
      source_address_prefix                      = "VirtualNetwork"
      destination_address_prefix                 = "Storage"
      access                                     = "Allow"
      priority                                   = 103
      direction                                  = "Outbound"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_ranges                    = []
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_ranges                         = []
    },
    {
      name                                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub"
      description                                = "Required for workers communication with Azure Eventhub services."
      protocol                                   = "tcp"
      source_port_range                          = "*"
      destination_port_range                     = "9903"
      source_address_prefix                      = "VirtualNetwork"
      destination_address_prefix                 = "EventHub"
      access                                     = "Allow"
      priority                                   = 104
      direction                                  = "Outbound"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_ranges                    = []
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_ranges                         = []
    },
    {
      name                                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp"
      description                                = "Required for workers communication with Databricks Webapp."
      protocol                                   = "tcp"
      source_port_range                          = "*"
      destination_port_range                     = "443"
      source_address_prefix                      = "VirtualNetwork"
      destination_address_prefix                 = "AzureDatabricks"
      access                                     = "Allow"
      priority                                   = 100
      direction                                  = "Outbound"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_ranges                    = []
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_ranges                         = []
    }
  ]
  */
  tags = var.tags
}

resource "azurerm_network_security_rule" "databricks-worker-to-worker-inbound" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound"
  description                 = "Required for worker nodes communication within a cluster."
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.rgName
  network_security_group_name = azurerm_network_security_group.databricks-nsg.name
  depends_on = [
    azurerm_network_security_group.databricks-nsg
  ]
}

resource "azurerm_network_security_rule" "databricks-control-plane-to-worker-ssh" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-control-plane-to-worker-ssh"
  description                 = "Required for Databricks control plane management of worker nodes."
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_address_prefix       = "AzureDatabricks"
  source_port_range           = "*"
  destination_port_range      = "22"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.rgName
  network_security_group_name = azurerm_network_security_group.databricks-nsg.name
  depends_on = [
    azurerm_network_security_group.databricks-nsg
  ]
}

resource "azurerm_network_security_rule" "databricks-control-plane-to-worker-proxy" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-control-plane-to-worker-proxy"
  description                 = "Required for Databricks control plane communication with worker nodes."
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_address_prefix       = "AzureDatabricks"
  source_port_range           = "*"
  destination_port_range      = "5557"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.rgName
  network_security_group_name = azurerm_network_security_group.databricks-nsg.name
  depends_on = [
    azurerm_network_security_group.databricks-nsg
  ]
}

resource "azurerm_network_security_rule" "databricks-worker-to-worker-outbound" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound"
  description                 = "Required for worker nodes communication within a cluster."
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  access                      = "Allow"
  priority                    = 101
  direction                   = "Outbound"
  resource_group_name         = var.rgName
  network_security_group_name = azurerm_network_security_group.databricks-nsg.name
  depends_on = [
    azurerm_network_security_group.databricks-nsg
  ]
}

resource "azurerm_network_security_rule" "databricks-worker-to-sql" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql"
  description                 = "Required for workers communication with Azure SQL services."
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Sql"
  access                      = "Allow"
  priority                    = 102
  direction                   = "Outbound"
  resource_group_name         = var.rgName
  network_security_group_name = azurerm_network_security_group.databricks-nsg.name
  depends_on = [
    azurerm_network_security_group.databricks-nsg
  ]
}

resource "azurerm_network_security_rule" "databricks-worker-to-storage" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage"
  description                 = "Required for workers communication with Azure Storage services."
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Storage"
  access                      = "Allow"
  priority                    = 103
  direction                   = "Outbound"
  resource_group_name         = var.rgName
  network_security_group_name = azurerm_network_security_group.databricks-nsg.name
  depends_on = [
    azurerm_network_security_group.databricks-nsg
  ]
}
resource "azurerm_network_security_rule" "databricks-worker-to-eventhub" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub"
  description                 = "Required for worker communication with Azure Eventhub services."
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "9093"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "EventHub"
  access                      = "Allow"
  priority                    = 104
  direction                   = "Outbound"
  resource_group_name         = var.rgName
  network_security_group_name = azurerm_network_security_group.databricks-nsg.name
  depends_on = [
    azurerm_network_security_group.databricks-nsg
  ]
}

resource "azurerm_network_security_rule" "databricks-worker-to-databricks-webapp" {
  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp"
  description                 = "Required for workers communication with Databricks Webapp."
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureDatabricks"
  access                      = "Allow"
  priority                    = 100
  direction                   = "Outbound"
  resource_group_name         = var.rgName
  network_security_group_name = azurerm_network_security_group.databricks-nsg.name
  depends_on = [
    azurerm_network_security_group.databricks-nsg
  ]
}

resource "azurerm_network_security_group" "aml_nsg" {
  name                = "${var.name}-aml-nsg"
  location            = var.location
  resource_group_name = var.rgName

  security_rule = [{
    name                                       = "AllowAzureMachineLearning"
    description                                = "Required for Azure Machine Learning Compute Clusters and Instances with public IP."
    protocol                                   = "tcp"
    source_port_range                          = "*"
    destination_port_range                     = "44224"
    source_address_prefix                      = "AzureMachineLearning"
    destination_address_prefix                 = "*"
    access                                     = "Allow"
    priority                                   = 120
    direction                                  = "Inbound"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_ranges                    = []
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_ranges                         = []
    },
    {
      name                                       = "AllowBatchNodeManagement"
      description                                = "Required for Azure Machine Learning Compute Clusters and Instances with public IP."
      protocol                                   = "tcp"
      source_port_range                          = "*"
      destination_port_range                     = "29876-29877"
      source_address_prefix                      = "BatchNodeManagement"
      destination_address_prefix                 = "*"
      access                                     = "Allow"
      priority                                   = 130
      direction                                  = "Inbound"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_ranges                    = []
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_ranges                         = []
    }
  ]

}

// NSG Associations
resource "azurerm_subnet_network_security_group_association" "default_nsg_services_subnet_assoc" {
  subnet_id                 = azurerm_subnet.ServicesSubnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.ServicesSubnet,
    azurerm_network_security_group.nsg
  ]
}

resource "azurerm_subnet_network_security_group_association" "dbricksIntPub_nsg_snet_assoc" {
  subnet_id                 = azurerm_subnet.DatabricksIntegrationPublicSubnet.id
  network_security_group_id = azurerm_network_security_group.databricks-nsg.id
  depends_on = [
    azurerm_subnet.DatabricksIntegrationPublicSubnet,
    azurerm_network_security_group.databricks-nsg
  ]
}
resource "azurerm_subnet_network_security_group_association" "dbricksIntPri_nsg_snet_assoc" {
  subnet_id                 = azurerm_subnet.DatabricksIntegrationPrivateSubnet.id
  network_security_group_id = azurerm_network_security_group.databricks-nsg.id
  depends_on = [
    azurerm_subnet.DatabricksIntegrationPrivateSubnet,
    azurerm_network_security_group.databricks-nsg
  ]
}
resource "azurerm_subnet_network_security_group_association" "dbricksPrdPub_nsg_snet_assoc" {
  subnet_id                 = azurerm_subnet.DatabricksProductPublicSubnet.id
  network_security_group_id = azurerm_network_security_group.databricks-nsg.id
  depends_on = [
    azurerm_subnet.DatabricksProductPublicSubnet,
    azurerm_network_security_group.databricks-nsg
  ]
}
resource "azurerm_subnet_network_security_group_association" "dbricksPrdPri_nsg_snet_assoc" {
  subnet_id                 = azurerm_subnet.DatabricksProductPrivateSubnet.id
  network_security_group_id = azurerm_network_security_group.databricks-nsg.id
  depends_on = [
    azurerm_subnet.DatabricksProductPrivateSubnet,
    azurerm_network_security_group.databricks-nsg
  ]
}
resource "azurerm_subnet_network_security_group_association" "pbigw_nsg_snet_assoc" {
  subnet_id                 = azurerm_subnet.PowerBIGatewaySubnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.PowerBIGatewaySubnet,
    azurerm_network_security_group.nsg
  ]
}
resource "azurerm_subnet_network_security_group_association" "dataInt001_nsg_snet_assoc" {
  subnet_id                 = azurerm_subnet.DataIntegration001Subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.DataIntegration001Subnet,
    azurerm_network_security_group.nsg
  ]
}
resource "azurerm_subnet_network_security_group_association" "dataInt002_nsg_snet_assoc" {
  subnet_id                 = azurerm_subnet.DataIntegration002Subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.DataIntegration002Subnet,
    azurerm_network_security_group.nsg
  ]
}
resource "azurerm_subnet_network_security_group_association" "dataPrd001_nsg_snet_assoc" {
  subnet_id                 = azurerm_subnet.DataProduct001Subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.DataProduct001Subnet,
    azurerm_network_security_group.nsg
  ]
}
resource "azurerm_subnet_network_security_group_association" "dataPrd002_nsg_snet_assoc" {
  subnet_id                 = azurerm_subnet.DataProduct002Subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.DataProduct002Subnet,
    azurerm_network_security_group.nsg
  ]
}


