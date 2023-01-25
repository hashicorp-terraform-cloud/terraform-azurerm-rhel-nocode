variable "vm_name" {
  description = "Azure Virtual Machine Name"
  type        = string
}

variable "vm_owner" {
  description = "Individual or Team responsible"
  type        = string
}

variable "vm_size" {
  description = "Azure Virtual Machine Size"
  default     = "Standard_D2as_v4"
  type        = string
}

variable "vm_sku" {
  description = "Azure RHEL Virtual Machine SKU"
  default     = "90-gen2"
  type        = string
}

variable "default_resource_tags" {
  description = "Azure Resource Tags"
  type        = map(any)
  default = {
    ManagedBy = "Terraform Cloud"
    OwnedBy   = "${var.vm_owner}"
  }
}

variable "rg_name" {
  description = "Resource Group Name"
  default     = "terraformDefaultRG"
  type        = string
}

variable "ssh_admin_user" {
  description = "Admin User SSH Username"
  type        = string
  default     = "rheluser"
}

variable "ssh_admin_user_public_key" {
  description = "Admin User SSH Public Key"
  type        = string
}

