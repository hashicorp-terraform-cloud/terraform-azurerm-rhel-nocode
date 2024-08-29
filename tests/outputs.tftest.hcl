
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "outputs" {
  assert {
    condition     = output.rhel_vm_id != null
    error_message = "Output should not be null"
  }

  assert {
    condition     = output.rhel_private_ip != null
    error_message = "Output should not be null"
  }

  assert {
    condition     = output.rhel_lb_public_ip != null
    error_message = "Output should not be null"
  }

  assert {
    condition     = output.rhel_default_username == var.ssh_admin_user
    error_message = "Output should match the input variable"
  }
}