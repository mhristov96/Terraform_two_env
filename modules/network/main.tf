resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "web_subnets" {
  for_each = var.subnets
  name                 = var.subnets[each.key].subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets[each.key].address_prefix]
}
resource "azurerm_network_interface" "nics" {
  for_each = var.network_interfaces_name
  name                = var.network_interfaces_name[each.key].network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web_subnets[each.value.subnet_name].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[each.value.public_ip_name].id
  }
}
resource "azurerm_public_ip" "public_ip" {
  for_each = var.public_ips
  name                = var.public_ips[each.key].public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# NSGS
resource "azurerm_network_security_group" "nsg" {
  for_each = var.network_security_groups
  name                = each.value.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "rules" {
  for_each = {
    for entry in flatten([
      for nsg_key, nsg in var.network_security_groups : [
        for rule in nsg.security_rules : {
          nsg_key = nsg_key
          rule    = rule
        }
      ]
    ]) : "${entry.nsg_key}-${entry.rule.name}" => entry
  }

  name                        = each.value.rule.name
  priority                    = each.value.rule.priority
  direction                   = each.value.rule.direction
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[each.value.nsg_key].name
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  for_each = var.network_interfaces_name
  network_interface_id      = azurerm_network_interface.nics[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.nsg_name].id
}