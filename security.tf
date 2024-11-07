resource "azurerm_network_security_group" "rhel" {
  name                = "${local.vm_name}-nsg"
  location            = data.azurerm_resource_group.compute_rg.location
  resource_group_name = data.azurerm_resource_group.compute_rg.name
}

resource "azurerm_network_security_rule" "rhel" {
  name                        = "AllowAnySSHInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = data.azurerm_resource_group.compute_rg.name
  network_security_group_name = azurerm_network_security_group.rhel.name
}

resource "azurerm_network_interface_security_group_association" "rhel" {
  network_interface_id      = azurerm_network_interface.rhel.id
  network_security_group_id = azurerm_network_security_group.rhel.id
}
