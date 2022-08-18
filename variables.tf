variable "vm_size" {
  description = "Azure Virtual Machine size"
  default     = "Standard_D2as_v4"
  type        = string
}

variable "vm_name" {
  description = "Azure Virtual Machine name"
  type        = string
}

variable "rg_name" {
  description = "Resource Group name"
  default     = "terraformDefaultRG"
  type        = string
}

variable "location" {
  description = "Location"
  default     = "uksouth"
  type        = string
}

variable "ssh_public_key" {
  description = "Admin User SSH Key"
  type        = string
}