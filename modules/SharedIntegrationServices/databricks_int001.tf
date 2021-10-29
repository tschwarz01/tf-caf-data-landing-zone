/*
module databricksIntegration001 'services/databricks.bicep' = {
  name: 'databricksIntegration001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    databricksName: databricksIntegration001Name
    vnetId: vnetId
    privateSubnetName: databricksIntegration001PrivateSubnetName
    publicSubnetName: databricksIntegration001PublicSubnetName
  }
}
*/

resource "azurerm_databricks_workspace" "databricksIntegration001" {
  name                = local.databricksIntegration001Name
  resource_group_name = var.rgName
  location            = var.location
  sku                 = "premium"

  custom_parameters {
    virtual_network_id  = var.vnetId
    public_subnet_name  = var.databricksIntegration001PublicSubnetName
    private_subnet_name = var.databricksIntegration001PrivateSubnetName
  }

  tags = var.tags
}


/*
output databricksId string = databricks.id
output databricksWorkspaceUrl string = databricks.properties.workspaceUrl
output databricksApiUrl string = 'https://${location}.azuredatabricks.net'
*/
