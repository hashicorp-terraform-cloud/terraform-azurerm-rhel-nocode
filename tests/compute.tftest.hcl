
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

variables {
  vm_instance_count = 1
  vm_size = "Standard_D2as_v4"
  ssh_admin_user = "rheluser"
  ssh_admin_user_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6+Z..."
  rhsm_activation_key = "my-activation-key"
  rhsm_organisation_id = "123456"
}

run "azurerm_public_ip" {
  assert {
    condition     = azurerm_public_ip.rhel.allocation_method == "Static"
    error_message = "Allocation method should be Static"
  }

  assert {
    condition     = azurerm_public_ip.rhel.sku == "Standard"
    error_message = "SKU should be Standard"
  }
}

run "azurerm_network_interface" {
  assert {
    condition     = azurerm_network_interface.rhel[0].ip_configuration[0].private_ip_address_allocation == "Dynamic"
    error_message = "Private IP address allocation should be Dynamic"
  }
}

run "azurerm_linux_virtual_machine" {
  assert {
    condition     = azurerm_linux_virtual_machine.rhel[0].size == var.vm_size
    error_message = "VM size should match the input variable"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.rhel[0].admin_username == var.ssh_admin_user
    error_message = "Admin username should match the input variable"
  }
}