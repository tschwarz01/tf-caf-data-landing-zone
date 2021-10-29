
locals {

  artifactstorage001Name     = "${var.prefix}artfctstg001"
  datafactoryRuntimes001Name = "${var.prefix}-runtime-datafactory001"
  shir001Name                = "${var.prefix}-shir001"
  shir002Name                = "${var.prefix}-shir002"
  vmssName                   = local.shir001Name
  loadbalancerName           = "${local.vmssName}-lb"
  fileUri                    = "https://raw.githubusercontent.com/Azure/data-landing-zone/main/code/installSHIRGateway.ps1"
  dataFactorySHIRauthkey     = azurerm_data_factory_integration_runtime_self_hosted.datafactorySelfHostedRuntime001.auth_key_1
}


resource "azurerm_data_factory" "dataFactory" {
  name                            = local.datafactoryRuntimes001Name
  location                        = var.location
  resource_group_name             = var.rgName
  public_network_enabled          = false
  tags                            = var.tags
  managed_virtual_network_enabled = true
  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_private_endpoint" "data_factory_private_endpoint" {
  name                = "${var.prefix}-${azurerm_data_factory.dataFactory.name}-adf-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${azurerm_data_factory.dataFactory.name}-adf-private-endpoint-connection"
    private_connection_resource_id = azurerm_data_factory.dataFactory.id
    subresource_names              = ["dataFactory"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDataFactory]
  }
}

resource "azurerm_private_endpoint" "data_factory_portal_private_endpoint" {
  name                = "${var.prefix}-${azurerm_data_factory.dataFactory.name}-adf-portal-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.prefix}-${azurerm_data_factory.dataFactory.name}-adf-portal-private-endpoint-connection"
    private_connection_resource_id = azurerm_data_factory.dataFactory.id
    subresource_names              = ["portal"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDataFactoryPortal]
  }
}


resource "azurerm_data_factory_integration_runtime_azure" "datafactoryManagedIntegrationRuntime001" {
  name                = "${var.prefix}-adf-managedIR-${azurerm_data_factory.dataFactory.name}"
  data_factory_name   = azurerm_data_factory.dataFactory.name
  resource_group_name = var.rgName
  location            = var.location
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "datafactorySelfHostedRuntime001" {
  name                = "${var.prefix}-adf-selfHostedIR-${azurerm_data_factory.dataFactory.name}"
  resource_group_name = var.rgName
  data_factory_name   = azurerm_data_factory.dataFactory.name
  depends_on = [
    azurerm_data_factory.dataFactory,
    azurerm_data_factory_integration_runtime_azure.datafactoryManagedIntegrationRuntime001
  ]
}

resource "azurerm_lb" "adfVmssLb001" {
  name                = "${local.vmssName}-lb"
  location            = var.location
  resource_group_name = var.rgName
  tags                = var.tags
  sku                 = "Basic"


  frontend_ip_configuration {
    name      = "feipconfig"
    subnet_id = var.svcSubnetId
  }
}

resource "azurerm_lb_backend_address_pool" "adf-lb-be-pool" {
  loadbalancer_id = azurerm_lb.adfVmssLb001.id
  name            = "${local.vmssName}-backend-pool"
}

resource "azurerm_lb_nat_pool" "adf-lb-nat-pool" {
  resource_group_name            = var.rgName
  loadbalancer_id                = azurerm_lb.adfVmssLb001.id
  name                           = "${local.vmssName}-natpool"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50099
  backend_port                   = 3389
  idle_timeout_in_minutes        = 4
  frontend_ip_configuration_name = azurerm_lb.adfVmssLb001.frontend_ip_configuration[0].name
}

resource "azurerm_lb_rule" "adf-lb-rule" {
  resource_group_name            = var.rgName
  loadbalancer_id                = azurerm_lb.adfVmssLb001.id
  name                           = "proberule"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.adf-lb-be-pool.id]
  frontend_ip_configuration_name = azurerm_lb.adfVmssLb001.frontend_ip_configuration[0].name
  load_distribution              = "Default"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 5
}


resource "azurerm_lb_probe" "adf-lb-probe" {
  resource_group_name = var.rgName
  loadbalancer_id     = azurerm_lb.adfVmssLb001.id
  name                = "${local.vmssName}-probe"
  port                = 80
  protocol            = "Http"
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}


resource "azurerm_windows_virtual_machine_scale_set" "vmss01" {
  name                = local.vmssName
  resource_group_name = var.rgName
  location            = var.location
  sku                 = "Standard_DS2_v2"
  instances           = 1
  admin_password      = var.vmAdminPassword
  admin_username      = var.vmAdminUserName

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = "${local.vmssName}-nic"
    primary                       = true
    enable_accelerated_networking = false

    ip_configuration {
      name                                   = "${local.vmssName}-ipconfig"
      primary                                = true
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.adf-lb-be-pool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.adf-lb-nat-pool.id]
      subnet_id                              = var.svcSubnetId

    }
  }
  extension {
    name                 = "${local.vmssName}-integrationruntime-shir"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.10"
    settings             = <<SETTINGS
        {
            "fileUris": [
                "https://raw.githubusercontent.com/Azure/data-landing-zone/main/code/installSHIRGateway.ps1"
                ]
        }
    SETTINGS
    protected_settings   = <<PROTECTED_SETTINGS
      {
          "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File installSHIRGateway.ps1 -gatewayKey ${local.dataFactorySHIRauthkey}"
      }
  PROTECTED_SETTINGS
  }
  depends_on = [
    azurerm_data_factory_integration_runtime_self_hosted.datafactorySelfHostedRuntime001
  ]
}

