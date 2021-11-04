resource "azurerm_databricks_workspace" "databricksProduct001" {
  name                = local.databricksProduct001Name
  resource_group_name = var.rgName
  location            = var.location
  sku                 = "premium"

  custom_parameters {
    virtual_network_id                                   = var.vnetId
    public_subnet_name                                   = var.databricksProduct001PublicSubnetName
    private_subnet_name                                  = var.databricksProduct001PrivateSubnetName
    public_subnet_network_security_group_association_id  = var.databricksIntegrationPublicNsgAssocId
    private_subnet_network_security_group_association_id = var.databricksIntegrationPrivateNsgAssocId
  }

  tags = var.tags
}
