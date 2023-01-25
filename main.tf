terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.40.0"
    }
  }
}

provider "azurerm" {
  features {}
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