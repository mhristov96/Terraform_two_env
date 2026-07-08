variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}
variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
}
variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
}
variable "source_image_reference" {
  description = "Linux VM image configuration"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "network_interface_id" {
  description = "The ID of the network interface"
  type        = string
}