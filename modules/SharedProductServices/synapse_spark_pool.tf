resource "azurerm_synapse_spark_pool" "synapseSparkPool001" {
  name                 = "SparkPool001"
  synapse_workspace_id = azurerm_synapse_workspace.synapseProduct001.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"

  auto_scale {
    max_node_count = 10
    min_node_count = 3
  }

  auto_pause {
    delay_in_minutes = 15
  }

  tags = {
    ENV = "Production"
  }
}
