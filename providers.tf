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
    subscription_id = getenv("AZURE_SUBSCRIPTION_ID")
    client_id       = getenv("AZURE_CLIENT_ID")
    client_secret   = getenv("AZURE_CLIENT_SECRET")
    tenant_id       = getenv("AZURE_TENANT_ID")
}