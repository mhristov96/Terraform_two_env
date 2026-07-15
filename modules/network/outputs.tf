output "network_interface_ids" {
  value = {
    for k, nic in azurerm_network_interface.nics :
    nic.name => nic.id
  }
}