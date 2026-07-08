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
  name                = var.network_interfaces_name[each.key].network_interfaces_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web_subnets[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
  }
}
resource "azurerm_public_ip" "public_ip" {
  for_each = var.public_ips
  name                = var.public_ips[each.key].public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}