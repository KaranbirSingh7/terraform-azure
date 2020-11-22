provider "azurerm" {
  version = "=1.44.0"
}

# Create VNET
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetName
  location            = var.resourceLocation
  resource_group_name = var.resourceGroup
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = var.resourceGroup
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.2.0/24"
}


# Create Public IP
resource "azurerm_public_ip" "myPIP" {
  name                = "jenkins-publicIP"
  resource_group_name = var.resourceGroup
  location            = var.resourceLocation
  allocation_method   = "Static"
}

# Create NIC
resource "azurerm_network_interface" "serverNIC_ID" {
  name                = "jenkins-interface"
  location            = var.resourceLocation
  resource_group_name = var.resourceGroup

  ip_configuration {
    name                          = "JenkinsIPConfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myPIP.id
  }
}

# Create VM
resource "azurerm_virtual_machine" "jenkinsServerVM" {
  name                  = var.vmName
  location              = var.resourceLocation
  resource_group_name   = var.resourceGroup
  network_interface_ids = [azurerm_network_interface.serverNIC_ID.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "cloudskillsdev01"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.tmp.pub")
    }
  }
}
