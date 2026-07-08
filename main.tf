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
  network_interfaces_name = local.conf.network_interfaces_name
  public_ips          = local.conf.public_ips

}