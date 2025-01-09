
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "compute_resources" {
  assert {
    condition     = azurerm_public_ip.rhel.allocation_method == "Static"
    error_message = "Public IP allocation method should be Static"
  }

  assert {
    condition     = azurerm_network_interface.rhel.ip_configuration.private_ip_address_allocation == "Dynamic"
    error_message = "Network interface IP address allocation should be Dynamic"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.rhel.size == var.vm_size
    error_message = "Virtual machine size does not match the input variable"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.rhel.admin_username == var.ssh_admin_user
    error_message = "Admin username does not match the input variable"
  }
}

# health.tftest.hcl
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "health_check" {
  assert {
    condition     = data.azurerm_virtual_machine.rhel.power_state == "running"
    error_message = "Virtual machine should be running"
  }
}

# identity.tftest.hcl
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "identity_check" {
  assert {
    condition     = azurerm_user_assigned_identity.rhel.name == "${local.vm_name}-identity"
    error_message = "User assigned identity name does not match the expected value"
  }
}

# main.tftest.hcl
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "main_check" {
  assert {
    condition     = data.azurerm_resource_group.compute_rg.name == var.rg_name
    error_message = "Resource group name does not match the input variable"
  }

  assert {
    condition     = local.vm_name == "${var.vm_name_prefix}-${random_pet.compute_id.id}"
    error_message = "Local VM name does not match the expected value"
  }
}

# outputs.tftest.hcl
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "outputs_check" {
  assert {
    condition     = output.rhel_vm_id == azurerm_linux_virtual_machine.rhel.id
    error_message = "Output VM ID does not match the actual VM ID"
  }

  assert {
    condition     = output.rhel_private_ip == azurerm_linux_virtual_machine.rhel.private_ip_address
    error_message = "Output private IP does not match the actual private IP"
  }

  assert {
    condition     = output.rhel_lb_public_ip == azurerm_public_ip.rhel.ip_address
    error_message = "Output LB public IP does not match the actual LB public IP"
  }

  assert {
    condition     = output.rhel_default_username == azurerm_linux_virtual_machine.rhel.admin_username
    error_message = "Output default username does not match the actual default username"
  }
}

# variables.tftest.hcl
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "variables_check" {
  assert {
    condition     = var.vm_size == "Standard_D2as_v5"
    error_message = "VM size variable should be Standard_D2as_v5"
  }

  assert {
    condition     = var.vm_sku == "94_gen2"
    error_message = "VM SKU variable should be 94_gen2"
  }

  assert {
    condition     = var.ssh_admin_user == "rheluser"
    error_message = "SSH admin user variable should be rheluser"
  }
}