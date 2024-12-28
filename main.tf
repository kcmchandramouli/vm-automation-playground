resource "azurerm_resource_group" "vm-automation-rg" {
  name = var.resource-group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vm-automation-vnet" {
  name                = "vm-automation-vnet"
  location            =  azurerm_resource_group.vm-automation-rg.location
  resource_group_name =  azurerm_resource_group.vm-automation-rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet for VNet
resource "azurerm_subnet" "vm-automation-subnet" {
  name                 = "vm-automation-subnet-1"
  resource_group_name  = azurerm_resource_group.vm-automation-rg.name
  virtual_network_name = azurerm_virtual_network.vm-automation-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Network Interface (NIC) for the VM
resource "azurerm_network_interface" "vm-automation-nic" {
  name                = "vm-automation-Nic"
  location            = azurerm_resource_group.vm-automation-rg.location
  resource_group_name = azurerm_resource_group.vm-automation-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm-automation-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#NSG for Ports
resource "azurerm_network_security_group" "vm-automation-NSG" {
  name                = "vm-automation-NSG"
  location            = azurerm_resource_group.vm-automation-rg.location
  resource_group_name = azurerm_resource_group.vm-automation-rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "automation-vm"
  resource_group_name   = azurerm_resource_group.vm-automation-rg.name
  location              = azurerm_resource_group.vm-automation-rg.location
  size                  = "Standard_B1s" # Change as required
  admin_username        = "kcm"
  admin_password        = "12345Kcm67890"
  disable_password_authentication = false  # Ensure this is false or omitted
  network_interface_ids = [azurerm_network_interface.vm-automation-nic.id]
  os_disk {
    name              = "vm-automation-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "test"
  }
}

# # Create the Storage Account
# resource "azurerm_storage_account" "vm-automation-storage-account" {
#   name                     = var.storage_account_name #"VM-Automation-Storage-Account"
#   resource_group_name       = azurerm_resource_group.vm-automation-rg.name
#   location                 = azurerm_resource_group.vm-automation-rg.location
#   account_tier              = "Standard"
#   account_replication_type = "LRS"

#   tags = {
#     environment = "Terraform"
#   }
# }

# # Create Blob container for Terraform state file
# resource "azurerm_storage_container" "vm-automation-storage-container" {
#   name                  =  var.storage_account_container_name #"Terraform-Blob-Container"
#   storage_account_name  = azurerm_storage_account.vm-automation-storage-account.name
#   container_access_type = "private"
# }

# terraform {
#   backend "azurerm" {
#     resource_group_name   = "cm-vm-automation"
#     storage_account_name  = "vmautostorageacc"
#     container_name        = "tf-blob-container"
#     key                   = "terraform.tfstate"
#   }
# }

# # # Output the kube_config for kubectl usage
# # output "kube_config" {
# #   value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
# # }
output "public_ip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}