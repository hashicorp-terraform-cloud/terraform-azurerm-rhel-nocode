
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "azurerm_user_assigned_identity" {
  assert {
    condition     = azurerm_user_assigned_identity.rhel.name == "${local.vm_name}-identity"
    error_message = "Identity name should match the local variable"
  }
}