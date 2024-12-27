variable "azure_subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "azure_client_id" {
  description = "The Azure client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "The Azure client secret"
  type        = string
}

variable "azure_tenant_id" {
  description = "The Azure tenant ID"
  type        = string
}

variable "resource-group_name" {
  description = "Default Resource Group name"
  type        = string
  default     = "cm-vm-automation"
}
variable "location" {
  description = "Location/Zone where the resources will be created"
  type        = string
  default     = "Central India"
}
variable "storage_account_name" {
  description = "Default Storage account name"
  type        = string
  default     = "VM-Automation-Storage-Account"
}
variable "storage_account_container_name" {
  description = "Default Container name in the Storage account"
  type        = string
  default     = "Terraform-Blob-Container"
}