
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "azurerm_lb" {
  assert {
    condition     = azurerm_lb.rhel.sku == "Standard"
    error_message = "Load balancer SKU should be Standard"
  }
}

run "azurerm_lb_backend_address_pool" {
  assert {
    condition     = azurerm_lb_backend_address_pool.rhel.name == "${local.vm_name}-web-address-pool"
    error_message = "Backend address pool name should match the local variable"
  }
}

run "azurerm_lb_nat_rule" {
  assert {
    condition     = azurerm_lb_nat_rule.ssh.backend_port == 22
    error_message = "Backend port should be 22"
  }
}

run "azurerm_lb_rule" {
  assert {
    condition     = azurerm_lb_rule.https.backend_port == 443
    error_message = "Backend port should be 443"
  }

  assert {
    condition     = azurerm_lb_rule.http.backend_port == 80
    error_message = "Backend port should be 80"
  }
}