output "nic_info1" {
    value = azurerm_network_interface.nics["nic1"].id

}
output "nic_info2" {
    value = azurerm_network_interface.nics["nic2"].id
}