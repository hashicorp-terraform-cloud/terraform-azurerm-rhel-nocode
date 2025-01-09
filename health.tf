data "azurerm_virtual_machine" "rhel" {
  name                = azurerm_linux_virtual_machine.rhel.name
  resource_group_name = data.azurerm_resource_group.compute_rg.name
}

check "check_vm_state" {
  assert {
    condition = data.azurerm_virtual_machine.rhel.power_state == "running"
    error_message = format("Virtual Machine (%s) should be in a 'running' status, instead state is '%s'",
      data.azurerm_virtual_machine.rhel.id,
      data.azurerm_virtual_machine.rhel.power_state
    )
  }
}
