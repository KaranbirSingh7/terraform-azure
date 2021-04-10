variable "aks_resource_group" {
  default     = "aks-rg"
  type        = string
  description = "Resource Group for Azure Kubernetes Service"
}

variable "aks_cluster_name" {
  type        = string
  description = "Name of AKS cluster"
  default     = ""
}

variable "aks_node_count" {
  default     = 3
  type        = number
  description = "Number of nodes in nodepool for AKS"
}
