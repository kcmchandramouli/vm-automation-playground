terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features { }
    subscription_id = "${{ vars.AZURE_SUBSCRIPTION_ID }}"
    client_id       = "${{ vars.AZURE_CLIENT_ID }}"
    client_secret   = "${{ vars.AZURE_CLIENT_SECRET }}"
    tenant_id       = "${{ vars.AZURE_TENANT_ID }}"
}