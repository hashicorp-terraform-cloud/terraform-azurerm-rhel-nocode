resource "azurerm_public_ip" "rhel" {
  name                = "${local.vm_name}-public"
  resource_group_name = data.azurerm_resource_group.compute_rg.name
  location            = data.azurerm_resource_group.compute_rg.location
  allocation_method   = "Static"
  public_ip_prefix_id = data.azurerm_public_ip_prefix.compute_pip.id

  tags = local.resource_tags
}

resource "azurerm_network_interface" "rhel" {
  name                = "${local.vm_name}-if"
  location            = data.azurerm_resource_group.compute_rg.location
  resource_group_name = data.azurerm_resource_group.compute_rg.name

  ip_configuration {
    name                          = "${local.vm_name}-internal"
    subnet_id                     = data.azurerm_subnet.compute_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rhel.id
  }

  tags = local.resource_tags
}

resource "azurerm_linux_virtual_machine" "rhel" {
  name                = local.vm_name
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

  custom_data = base64encode(templatefile("${path.module}/templates/custom-data.sh.tpl", {
    var_rhsm_organisation_id = var.rhsm_organisation_id
    var_rhsm_activation_key  = var.rhsm_activation_key
  }))

  network_interface_ids = [
    azurerm_network_interface.rhel.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # BYOS
  # source_image_reference {
  #   publisher = "redhat"
  #   offer     = "rhel-byos"
  #   sku       = var.vm_sku
  #   version   = "latest"
  # }

  # plan {
  #   name      = var.vm_sku
  #   publisher = "redhat"
  #   product   = "rhel-byos"
  # }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "94_gen2"
    version   = "latest"
  }

  tags = local.resource_tags
}
