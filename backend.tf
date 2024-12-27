terraform {
  backend "azurerm" {
    resource_group_name   = var.resource_group_name    #azurerm_resource_group.vm-automation-rg.name
    storage_account_name  = var.storage_account_name   #azurerm_storage_account.vm-automation-storage-account.name
    container_name        = var.storage_account_container_name    #azurerm_storage_container.vm-automation-storage-container.name
    key                   = "terraform.tfstate"
  }
}
