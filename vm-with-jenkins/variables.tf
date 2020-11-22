variable "resource_group" {}

variable "vm_username" {}
variable "vm_password" {}
variable "os_name" {}
variable "vm_size" { default = "Basic_A1" }
variable "vm_name" { default = "jenkins_vm" }

variable "network_name" {
  default = "jenkins-vnet"
}

variable "subnet_name" { default = "jenkins-subnet" }

variable "location" {
  default = "Central US"
}

