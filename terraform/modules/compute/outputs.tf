output "vm_private_ips" {
  description = "List of private IP addresses assigned to the VM network interfaces."
  value       = [for nic in azurerm_network_interface.nic : nic.private_ip_address]
}