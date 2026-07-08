resource "azurerm_resource_group" "appgrp" {
  name     = "test123"
  location = "westeurope"
}
locals {
    conf = jsondecode(file("${path.module}/${var.env}.json"))
}
module "network" {
  source              = "./modules/network"
  vnet_name           = local.conf.vnet_name
  vnet_address_space  = local.conf.vnet_address_space
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = azurerm_resource_group.appgrp.location
}