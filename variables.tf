variable "subscription_id" {
  description = "The Azure subscription ID to use for the provider."
  type        = string
}

variable "resource_group" {
  description = "An existing Sandbox Resource Group."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
  default     = "UK South"
}

variable "vm_size" {
  description = "The size of the Virtual Machine."
  type        = string
  default     = "Standard_B1s" # Low cost burstable tier perfect for sandboxes
}

variable "admin_username" {
  description = "The local administrator username for the VM."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "The local path to your public SSH key used for authentication."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}