variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}
variable "vnet_address_space" {
  description = "The address space of the virtual network"
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}
variable "location" {
  description = "The location of the virtual network"
  type        = string
}
variable "subnets" {
  description = "A map of subnets to create"
  type        = map(object({
  subnet_name           = string
  address_prefix = string
  }))
}
variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
}
variable "public_ips" {
  description = "The name of the public IP address"
  type        = map(object({
  public_ip_name = string
  }))
}