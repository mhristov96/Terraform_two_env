locals {
    conf = jsondecode(file("${path.module}/${var.env}.json"))
}

resource "azurerm_resource_group" "appgrp" {
  name     = local.conf.resource_group_name
  location = local.conf.resource_group_location
}

module "network" {
  source                  = "./modules/network"
  vnet_name               = local.conf.vnet_name
  vnet_address_space      = local.conf.vnet_address_space
  resource_group_name     = azurerm_resource_group.appgrp.name
  location                = azurerm_resource_group.appgrp.location
  subnets                 = local.conf.subnets
  network_interfaces_name = local.conf.network_interfaces_name
  public_ips              = local.conf.public_ips
  network_security_groups = local.conf.network_security_groups
}
module "compute" {
  source = "./modules/compute"
  vm_names = local.conf.vm_names
  vm_size = local.conf.vm_size
  source_image_reference = local.conf.source_image_reference
  admin_username = local.conf.admin_username
  admin_password = local.conf.admin_password
  resource_group_name = local.conf.resource_group_name
  network_interface_id = module.network.nic_info1
  resource_group_location = local.conf.resource_group_location
  }
