locals {
    conf = jsondecode(file("${path.module}/${var.env}.json"))
}

resource "azurerm_resource_group" "appgrp" {
  name     = local.conf.resource_group_name
  location = "westeurope"
}

module "network" {
  source              = "./modules/network"
  vnet_name           = local.conf.vnet_name
  vnet_address_space  = local.conf.vnet_address_space
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = azurerm_resource_group.appgrp.location
  subnets             = local.conf.subnets
}

resource "azurerm_subnet" "web_subnet01" {
  for_each = local.conf.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.appgrp.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = [each.value.address_prefix]
  depends_on = [azurerm_virtual_network.app_vnet]
}