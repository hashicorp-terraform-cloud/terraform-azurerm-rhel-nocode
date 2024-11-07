
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "variables" {
  assert {
    condition     = var.vm_name_prefix != null
    error_message = "Variable should not be null"
  }

  assert {
    condition     = var.vm_owner != null
    error_message = "Variable should not be null"
  }

  assert {
    condition     = var.vm_size == "Standard_D2as_v4"
    error_message = "Variable should match the default value"
  }

  assert {
    condition     = var.vm_instance_count != null
    error_message = "Variable should not be null"
  }

  assert {
    condition     = var.vm_sku == "rhel-lvm91-gen2"
    error_message = "Variable should match the default value"
  }

  assert {
    condition     = var.extra_tags != null
    error_message = "Variable should not be null"
  }

  assert {
    condition     = var.rg_name != null
    error_message = "Variable should not be null"
  }

  assert {
    condition     = var.ssh_admin_user == "rheluser"
    error_message = "Variable should match the default value"
  }

  assert {
    condition     = var.ssh_admin_user_public_key != null
    error_message = "Variable should not be null"
  }

  assert {
    condition     = var.rhsm_activation_key != null
    error_message = "Variable should not be null"
  }

  assert {
    condition     = var.rhsm_organisation_id != null
    error_message = "Variable should not be null"
  }
}