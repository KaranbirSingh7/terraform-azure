locals {
  formatted_timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
  aks_cluster_name    = var.aks_cluster_name != "" ? var.aks_cluster_name : "myaks${local.formatted_timestamp}"
}

data "azurerm_resource_group" "aks" {
  name = var.aks_resource_group
}

resource "azurerm_kubernetes_cluster" "mycluster" {
  name                = local.aks_cluster_name
  location            = data.azurerm_resource_group.aks.location
  resource_group_name = var.aks_resource_group
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = "Standard_DS1_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }
}