# Create Public IP
resource "azurerm_public_ip" "jenkins_pip" {
  name                = "jenkins-publicIP"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
}

# Create NIC
resource "azurerm_network_interface" "jenkins_nic" {
  name                = "jenkins-interface"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "jenkins-private-ip"
    subnet_id                     = azurerm_subnet.jenkins_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins_pip.id
  }
}
