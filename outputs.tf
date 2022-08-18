output "rhel_private_ip" {
    value       = azurerm_linux_virtual_machine.rhel.private_ip_address
    description = "The Private IP Adress of the Azure Virtual Machine Instance"
}

output "rhel_public_ip" {
    value       = azurerm_linux_virtual_machine.rhel.public_ip_address
    description = "The Public IP Adress of the Azure Virtual Machine Instance"
}

output "rhel_default_username" {
    value       = azurerm_linux_virtual_machine.rhel.admin_username
    description = "The Default Admin Username of the Azure Virtual Machine Instance"
}