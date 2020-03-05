output "ip_address" {
  value = vsphere_virtual_machine.vm.default_ip_address
}

output "user" {
  value = var.bootcamp_user
}

output "ssh_private_key" {
  value = tls_private_key.installkey.private_key_pem
}

output "ssh_public_key" {
  value = tls_private_key.installkey.public_key_openssh
}
