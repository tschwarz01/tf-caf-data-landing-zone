resource "azurerm_databricks_workspace" "databricksIntegration001" {
  name                = local.databricksIntegration001Name
  resource_group_name = var.rgName
  location            = var.location
  sku                 = "premium"

  custom_parameters {
    virtual_network_id                                   = var.vnetId
    public_subnet_name                                   = var.databricksIntegration001PublicSubnetName
    private_subnet_name                                  = var.databricksIntegration001PrivateSubnetName
    public_subnet_network_security_group_association_id  = var.databricksIntegrationPublicNsgAssocId
    private_subnet_network_security_group_association_id = var.databricksIntegrationPrivateNsgAssocId
  }

  tags = var.tags
}
