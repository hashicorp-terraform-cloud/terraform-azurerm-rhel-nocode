resource "ansible_host" "rhel-hosts" {
  count = var.vm_instance_count

  name   = azurerm_linux_virtual_machine.rhel[count.index].name
  groups = [local.vm_name]

  variables = {
    ansible_user = var.ssh_admin_user
    ansible_host = azurerm_public_ip.rhel[count.index].ip_address
  }
}