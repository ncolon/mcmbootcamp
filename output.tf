output "ip_address" {
  value = vsphere_virtual_machine.vm.default_ip_address
}

output "user" {
  value = var.username
}
