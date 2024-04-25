variable "resource_group_name" {
  type        = string
  description = "Name of the existing resource group."
}

variable "location" {
  type        = string
  description = "Azure region where the VM will be located."
  default     = "East US" # Default to East US if not specified
}

variable "shared_image_gallery_name" {
  type        = string
  description = "The name of the Shared Image Gallery"
}

variable "image_gallery_resource_group_name" {
  type        = string
  description = "The resource group name where the Shared Image Gallery is located"

}

variable "shared_image_version" {
  type        = string
  description = "The specific version of the shared image to use"
  default     = "latest"
}

variable "shared_image_name" {
  type        = string
  description = "The name of the image within the Shared Image Gallery"
}

// Required only if disk encryption is enabled (true) to specify the customer-managed key (CMK). 
variable "key_vault_resource_group_name" {
  type        = string
  description = "The resource group name where the key vault is located"
  default     = null
}

// Required only if disk encryption is enabled (true) to specify the customer-managed key (CMK).
variable "key_vault_disk_encrytion_id" {
  type        = string
  description = "Provide disk encryption ID if enabling CMK key on OS disk."
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of exisiting subnet IDs."
}

variable "vm_name" {
  type        = string
  description = "Base name for the virtual machines."
}

variable "vm_size" {
  type        = string
  description = "Size of the virtual machine."
}

variable "admin_username" {
  type        = string
  description = "Administrator username for the VM."
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the VM."
  sensitive   = true
}

variable "windows_vm_count" {
  type        = number
  description = "Number of Windows VMs to create."
  default     = 1
  validation {
    condition     = var.windows_vm_count >= 1 && var.windows_vm_count <= 3
    error_message = "The number of Windows VMs must be between 1 and 3."
  }
}

variable "os_disk_size" {
  type        = number
  description = "Size of the OS Disk (GB)"
  default     = null

  validation {
    condition     = var.os_disk_size == null ? true : var.os_disk_size >= 127
    error_message = "The Windows OS disk size must be more than 126 GB."
  }
}

variable "enable_automatic_updates" {
  type        = bool
  description = "Enable automatic OS updates."
  default     = true
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}


//VM Trusted Configuration

variable "secure_boot_enabled" {
  description = "Secure Boot for virtual machines as part of the Trusted Launch configuration."
  type        = bool
  default     = true

}

variable "vtpm_enabled" {
  description = "vTPM for virtual machines as part of the Trusted Launch configuration."
  type        = bool
  default     = true
}

variable "integrity_monitoring" {
  description = "Integrity Monitoring for virtual machines as part of the Trusted Launch configuration."
  type        = bool
  default     = true
}