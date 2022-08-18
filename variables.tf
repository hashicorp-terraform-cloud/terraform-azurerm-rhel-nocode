variable "vm_name" {
  description = "Azure Virtual Machine name"
  type        = string
}

variable "vm_size" {
  description = "Azure Virtual Machine size"
  default     = "Standard_D2as_v4"
  type        = string
}

variable "vm_sku" {
  description = "Azure RHEL Virtual Machine SKU"
  default     = "90-gen2"
  type        = string
} 

variable "vm_tags" {
  description = "Azure Virtual Machine SKU"
  default     = {}
  type = map
} 

variable "rg_name" {
  description = "Resource Group Name"
  default     = "terraformDefaultRG"
  type        = string
}

variable "location" {
  description = "Resource Location"
  default     = "uksouth"
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

