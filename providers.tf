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
    subscription_id = "${{ secrets.SUBSCRIPTIONID }}"
    client_id =  "${{ secrets.CLIENTID }}"
    client_secret =   "${{ secrets.CLIENTSECRET }}"
    tenant_id =   "${{ secrets.TENANTID }}"
}