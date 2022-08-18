terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.18.0"
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
  name                = format("%s-%s", data.azurerm_resource_group.compute_rg.name, "network")
  resource_group_name = data.azurerm_resource_group.compute_rg.name
}

data "azurerm_subnet" "compute_sn" {
  name                 = format("%s-%s", data.azurerm_resource_group.compute_rg.name, "subnet")
  virtual_network_name = data.azurerm_virtual_network.compute_vn.name
  resource_group_name  = data.azurerm_resource_group.compute_rg.name
}

resource "azurerm_public_ip" "rhel" {
  name                = format("%s-%s", var.vm_name, "public") 
  resource_group_name = data.azurerm_resource_group.compute_rg.name
  location            = data.azurerm_resource_group.compute_rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "rhel" {
  name                = format("%s-%s", var.vm_name, "if") 
  location            = data.azurerm_resource_group.compute_rg.location
  resource_group_name = data.azurerm_resource_group.compute_rg.name

  ip_configuration {
    name                          = format("%s-%s", var.vm_name, "internal") 
    subnet_id                     = data.azurerm_subnet.compute_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rhel.id
  }
}

resource "azurerm_linux_virtual_machine" "rhel" {
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.compute_rg.name
  location            = data.azurerm_resource_group.compute_rg.location
  size                = var.vm_size
  admin_username      = var.ssh_admin_user
  network_interface_ids = [
    azurerm_network_interface.rhel.id,
  ]

  admin_ssh_key {
    username   = var.ssh_admin_user
    public_key = var.ssh_admin_user_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = var.vm_sku
    version   = "latest"
  }

  tags = var.vm_tags
}