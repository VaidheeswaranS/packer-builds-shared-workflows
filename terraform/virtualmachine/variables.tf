variable "subscription_id" {
  type        = string
  description = "Subscription ID to deploy the resources"
  default     = null
}

variable "resource_group" {
  type        = string
  description = "Name of the existing resource group."
  default     = null
}

variable "image_gallery_resource_group" {
  type        = string
  description = "Name of the image gallery resource group."
}

variable "location" {
  type        = string
  description = "Azure region where the VM will be located."
  default     = "East US" # Default to East US if not specified
}

variable "shared_gallery" {
  description = "The name of the Shared Image Gallery"
  type        = string
}

variable "shared_image" {
  description = "The name of the image within the Shared Image Gallery"
  type        = string
}

variable "subnet" {
  type        = string
  description = "Subnet ID to attach VM"
}

variable "vm_size" {
  type        = string
  description = "Size of the virtual machine."
}

variable "windows_username" {
  type        = string
  description = "Administrator username for the VM."
  default     = "builduser"
}

variable "key_vault" {
  type        = string
  description = "ID of the key vault that contains the windows password."
}

variable "secret_name" {
  type        = string
  description = "Name of the secret which contains the windows password."
}

variable "vm_name" {
  type        = string
  description = "Name of the VM being created."
}

variable "vm_count" {
  type        = number
  description = "Number of Windows VMs to create."
  default     = 1
}