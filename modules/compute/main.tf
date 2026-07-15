resource "azurerm_linux_virtual_machine" "webvm01" {
  for_each = var.vm_names
  name                = var.vm_names[each.key].vm_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  custom_data        = base64encode(file("${path.module}/cloudinit"))
  network_interface_ids = module.network.nic_info[each.value.nic_name].id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
}



