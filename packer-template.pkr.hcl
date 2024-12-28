packer {
    required_plugins {
        azure = {
            version = ">= 1.0.0"
            source  = "github.com/hashicorp/azure"
        }
    }
}

source "azure-arm" "ubuntu" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  resource_group_name = "cm-vm-automation"  # Name of your Azure resource group
  image_publisher     = "Canonical"            # Publisher for Ubuntu images
  image_offer         = "0001-com-ubuntu-server-jammy"         # Ubuntu image offer
  image_sku           = "22_04-lts"            # Ubuntu version

  # Configure the VM size for building the image
  vm_size = "Standard_B1s"

  # Specify the Azure region
  region = "Central India"
}