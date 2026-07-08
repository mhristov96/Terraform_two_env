resource "azurerm_linux_virtual_machine" "webvm01" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = azurerm_resource_group.appgrp.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.appsecret.value
  disable_password_authentication = false
  custom_data        = base64encode(file("${path.module}/cloudinit"))
  network_interface_ids = [
    azurerm_network_interface.nics["nic1"].id
  ]

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
data "local_file" "cloudinit" {
  filename = "cloudinit"
}
