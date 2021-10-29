resource "azurerm_synapse_sql_pool" "synapseSqlPool001" {
  name                 = "SqlPool001"
  synapse_workspace_id = azurerm_synapse_workspace.synapseProduct001.id
  sku_name             = "DW300c"
  create_mode          = "Default"
  data_encrypted       = true
  tags                 = var.tags
  depends_on = [
    azurerm_synapse_workspace.synapseProduct001
  ]
}
