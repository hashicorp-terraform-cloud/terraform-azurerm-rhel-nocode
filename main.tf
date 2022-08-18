terraform {
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.18.0"
    }
  }

  required_version = ">= 1.2.7"
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
  resource_group_name = azurerm_resource_group.compute_rg.name
  location            = azurerm_resource_group.compute_rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "rhel" {
  name                = format("%s-%s", var.vm_name, "if") 
  location            = azurerm_resource_group.compute_rg.location
  resource_group_name = azurerm_resource_group.compute_rg.name

  ip_configuration {
    name                          = format("%s-%s", var.vm_name, "internal") 
    subnet_id                     = azurerm_subnet.rhel.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "azurerm_public_ip.rhel.id"
  }
}

resource "azurerm_linux_virtual_machine" "rhel" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rhel.name
  location            = azurerm_resource_group.rhel.location
  size                = var.vm_size
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.rhel.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "90-gen2"
    version   = "latest"
  }

  # tags = azurerm_resource_group.rhel.tags
}