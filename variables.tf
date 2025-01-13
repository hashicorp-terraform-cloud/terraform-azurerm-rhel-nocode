variable "vm_name_prefix" {
  description = "Each VM is created with a randomly generated name. Assign a common prefix."
  type        = string
}

variable "vm_owner" {
  description = "Individual or Team responsible"
  type        = string
}

variable "vm_size" {
  description = "Azure Virtual Machine Size"
  default     = "Standard_D2as_v5"
  type        = string

  validation {
    condition     = startswith(var.vm_size, "Standard_")
    error_message = "VM size must start with 'Standard_'. Got: ${var.vm_size}"
  }

  validation {
    condition     = endswith(var.vm_size, "_v5")
    error_message = "VM size must end with '_v5'. Got: ${var.vm_size}"
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9-_]*$", var.vm_size))
    error_message = "VM size contains invalid characters. Only alphanumeric characters, hyphens, and underscores are allowed. Got: ${var.vm_size}"
  }
}

variable "vm_sku" {
  description = "Azure RHEL Virtual Machine SKU"
  default     = "94_gen2"
  type        = string
}

variable "extra_tags" {
  description = "Extra Azure Resource Tags"
  type        = map(any)
  default     = {}
}

variable "rg_name" {
  description = "Target Resource Group Name"
  type        = string
}

variable "ssh_admin_user" {
  description = "Admin User SSH Username"
  type        = string
  default     = "rheluser"
}

variable "ssh_admin_user_public_key" {
  description = "Admin User SSH Public Key configured on the host at deploy time"
  type        = string
}

variable "rhsm_activation_key" {
  description = "RHSM Activation Key"
  type        = string
}

variable "rhsm_organisation_id" {
  description = "RHSM Organisation ID"
  type        = string
}
