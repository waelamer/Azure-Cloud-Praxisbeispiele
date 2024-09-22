
resource "azurerm_resource_group" "rg-spoke" {
  for_each = var.vnets

  name     = "rg-${each.value.name}-${var.product_name}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet-spoke" {
  for_each = var.vnets

  name                = "vnet-${each.value.name}-${var.product_name}"
  address_space       = [each.value.address_space]
  location            = azurerm_resource_group.rg-spoke[each.key].location
  resource_group_name = azurerm_resource_group.rg-spoke[each.key].name
  tags                = var.tags

  dynamic "subnet" {
    for_each = each.value.subnets
    content {
      name             = subnet.key
      address_prefixes = [subnet.value.address_prefix]
    }
  }
}

resource "azurerm_network_security_group" "nsg_frontend" {
  name                = "nsg-frontend-${var.product_name}"
  location            = azurerm_resource_group.rg-spoke["prod"].location
  resource_group_name = azurerm_resource_group.rg-spoke["prod"].name
  tags                = var.tags

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.4.0.0/22"
  }
}

resource "azurerm_network_security_group" "nsg_backend" {
  name                = "nsg-backend-${var.product_name}"
  location            = azurerm_resource_group.rg-spoke["prod"].location
  resource_group_name = azurerm_resource_group.rg-spoke["prod"].name
  tags                = var.tags

  security_rule {
    name                       = "allow-frontend-to-backend"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.4.0.0/22"
    destination_address_prefix = "10.4.4.0/22"
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "frontend_nsg_assoc" {
  subnet_id                 = local.frontend_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg_frontend.id
}

resource "azurerm_subnet_network_security_group_association" "backend_nsg_assoc" {
  subnet_id                 = local.backend_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg_backend.id
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each = { for k, v in var.vnets : k => v if k != "hub" }

  name                         = "hub-to-${each.value.name}-peering"
  resource_group_name          = azurerm_resource_group.rg-spoke["hub"].name
  virtual_network_name         = azurerm_virtual_network.vnet-spoke["hub"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke[each.key].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each = { for k, v in var.vnets : k => v if k != "hub" }

  name                         = "${each.value.name}-to-hub-peering"
  resource_group_name          = azurerm_resource_group.rg-spoke[each.key].name
  virtual_network_name         = azurerm_virtual_network.vnet-spoke[each.key].name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke["hub"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
  allow_gateway_transit        = false
}


