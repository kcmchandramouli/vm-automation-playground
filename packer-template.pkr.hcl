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

  # # Specify the image you want to start with
  managed_image_resource_group_name = "cm-vm-automation"
  managed_image_name                = "nginx-image"

  os_type                            = "Linux"
  image_publisher                    = "Canonical"
  image_offer                        = "0001-com-ubuntu-server-jammy"
  image_sku                          = "22_04-lts-gen2"
  location                           = "Central India"
  vm_size                            = "Standard_B2ms"
  os_disk_size_gb                    = 30
}

# Define the build block to create the image
build {
  name = "ubuntu-vm-azure-image"
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

  # # Post-processor: Use Azure CLI to upload the resulting VHD to Blob Storage
  # post-processor "shell" {
  #   inline = [
  #     "az storage blob upload --account-name ${var.storage_account_name} --container-name ${var.container_name} --name 'packer-vm-image.vhd' --file '/tmp/packer-azure-arm.vhd' --auth-mode key"
  #   ]
  # }
}

# Define variables to be substituted with the environment variables
variable "azure_client_id" {
  default = "env.TF_VAR_azure_client_id" # Reference the environment variable
}

variable "azure_client_secret" {
  default = "env.TF_VAR_azure_client_secret" # Reference the environment variable
}

variable "azure_tenant_id" {
  default = "env.TF_VAR_azure_tenant_id" # Reference the environment variable
}

variable "azure_subscription_id" {
  default = "env.TF_VAR_azure_subscription_id" # Reference the environment variable
}