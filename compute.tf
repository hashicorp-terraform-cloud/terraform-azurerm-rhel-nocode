resource "azurerm_public_ip" "rhel" {
  name                = "${local.vm_name}-public"
  resource_group_name = data.azurerm_resource_group.compute_rg.name
  location            = data.azurerm_resource_group.compute_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.resource_tags
}

resource "azurerm_network_interface" "rhel" {
  count               = var.vm_instance_count
  name                = "${local.vm_name}-${count.index}-if"
  location            = data.azurerm_resource_group.compute_rg.location
  resource_group_name = data.azurerm_resource_group.compute_rg.name

  ip_configuration {
    name                          = "${local.vm_name}-${count.index}-internal"
    subnet_id                     = data.azurerm_subnet.compute_sn.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.resource_tags
}

resource "azurerm_linux_virtual_machine" "rhel" {
  count               = var.vm_instance_count
  name                = "${local.vm_name}-${count.index}"
  resource_group_name = data.azurerm_resource_group.compute_rg.name
  location            = data.azurerm_resource_group.compute_rg.location
  size                = var.vm_size
  admin_username      = var.ssh_admin_user

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.rhel.id]
  }

  admin_ssh_key {
    username   = var.ssh_admin_user
    public_key = var.ssh_admin_user_public_key
  }

  custom_data = base64encode(local.custom_data)

  network_interface_ids = [
    azurerm_network_interface.rhel[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # BYOS
  source_image_reference {
    publisher = "redhat"
    offer     = "rhel-byos"
    sku       = var.vm_sku
    version   = "latest"
  }

  plan {
    name      = var.vm_sku
    publisher = "redhat"
    product   = "rhel-byos"
  }

  # Marketplace
  # source_image_reference {
  #     "publisher" : "RedHat",
  #     "offer" : "RHEL",
  #     "sku" : "9-lvm-gen2",
  #     "version" : "latest"
  # }

  tags = local.resource_tags
}

resource "azurerm_lb" "rhel" {
  name                = "${local.vm_name}-lb"
  sku                 = "Standard"
  location            = data.azurerm_resource_group.compute_rg.location
  resource_group_name = data.azurerm_resource_group.compute_rg.name

  frontend_ip_configuration {
    name                 = "${local.vm_name}-lb-public-ip"
    public_ip_address_id = azurerm_public_ip.rhel.id
  }

  tags = local.resource_tags
}

resource "azurerm_lb_backend_address_pool" "rhel" {
  loadbalancer_id = azurerm_lb.rhel.id
  name            = "${local.vm_name}-address-pool"
}

resource "azurerm_lb_backend_address_pool_address" "rhel" {
  count                   = var.vm_instance_count
  name                    = "${local.vm_name}-${count.index}-pool-address"
  backend_address_pool_id = azurerm_lb_backend_address_pool.rhel.id
  ip_address              = azurerm_network_interface.rhel[count.index].private_ip_address
  virtual_network_id      = data.azurerm_virtual_network.compute_vn.id
}