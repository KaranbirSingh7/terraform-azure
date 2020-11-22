resource "azurerm_virtual_network" "jenkins_vnet" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_subnet" "jenkins_subnet" {
  name                 = var.subnet_name
  address_prefix       = "10.0.2.0/24"
  virtual_network_name = var.network_name
  resource_group_name  = var.resource_group
}
