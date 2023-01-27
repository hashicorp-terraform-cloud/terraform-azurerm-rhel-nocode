resource "azurerm_public_ip" "rhel" {
  name                = "${var.vm_name_prefix}-public"
  resource_group_name = data.azurerm_resource_group.compute_rg.name
  location            = data.azurerm_resource_group.compute_rg.location
  allocation_method   = "Dynamic"

  tags = var.default_resource_tags
}

resource "azurerm_network_interface" "rhel" {
  name                = "${var.vm_name_prefix}-if"
  location            = data.azurerm_resource_group.compute_rg.location
  resource_group_name = data.azurerm_resource_group.compute_rg.name

  ip_configuration {
    name                          = "${var.vm_name_prefix}-internal"
    subnet_id                     = data.azurerm_subnet.compute_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rhel.id
  }

  tags = var.default_resource_tags
}

resource "azurerm_linux_virtual_machine" "rhel" {
  count               = var.vm_instance_count     
  name                = "${var.vm_name_prefix}-${random_pet.compute_id.id}-${count.index}"
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

  tags = var.default_resource_tags
}