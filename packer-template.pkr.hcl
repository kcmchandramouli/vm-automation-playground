packer {
    required_plugins {
        azure = {
            version = ">= 1.0.0"
            source  = "github.com/hashicorp/azure"
        }
    }
}

source "azure-arm" "ubuntu" {
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id

  resource_group_name = "cm-vm-automation"  # Name of your Azure resource group
  image_publisher     = "Canonical"            # Publisher for Ubuntu images
  image_offer         = "0001-com-ubuntu-server-jammy"         # Ubuntu image offer
  image_sku           = "22_04-lts"            # Ubuntu version

  # Configure the VM size for building the image
  vm_size = "Standard_B1s"

  # Specify the Azure region
#   region = "Central India"

  # Required parameters that were missing
  capture_container_name      = "packer-images"             # The container name where the captured image will be stored
  managed_image_name          = "ubuntu-packer-image"       # The name of the managed image to be created
  managed_image_resource_group_name = "cm-vm-automation"  # Resource group name for the managed image
  os_type                     = "Linux"                     # OS type for the image (Linux in this case)
  
  # Storage account to store temporary build data
  storage_account             = "cmstorageaccount1"      # A storage account for the build process
}

# Define the build block to create the image
build {
  name    = "ubuntu-vm-azure-image"
  sources = [
    "source.azure-arm.ubuntu"
  ]

  # Provisioning step: Install software (e.g., nginx)
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}

# Define variables to be substituted with the environment variables
variable "azure_client_id" {
  default = "env.TF_VAR_azure_client_id"   # Reference the environment variable
}

variable "azure_client_secret" {
  default = "env.TF_VAR_azure_client_secret" # Reference the environment variable
}

variable "azure_tenant_id" {
  default = "env.TF_VAR_azure_tenant_id"    # Reference the environment variable
}

variable "azure_subscription_id" {
  default = "env.TF_VAR_azure_subscription_id" # Reference the environment variable
}