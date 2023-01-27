terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {

}

data "azurerm_resource_group" "compute_rg" {
  name = var.rg_name
}

data "azurerm_virtual_network" "compute_vn" {
  name                = "${data.azurerm_resource_group.compute_rg.name}-network"
  resource_group_name = data.azurerm_resource_group.compute_rg.name
}

data "azurerm_subnet" "compute_sn" {
  name                 = "${data.azurerm_resource_group.compute_rg.name}-subnet"
  virtual_network_name = data.azurerm_virtual_network.compute_vn.name
  resource_group_name  = data.azurerm_resource_group.compute_rg.name
}

resource "random_pet" compute_id {
    length = 3
    special = false
    keepers = {
      owner = var.vm_owner
    }

}

locals {
  default_resource_tags = merge({
    OwnedBy = var.vm_owner
  }, var.extra_resource_tags)
}
