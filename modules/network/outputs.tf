output "network_interface_ids" {
  value = {
    for k, nic in azurerm_network_interface.nics :
    k => nic.id
  }
}