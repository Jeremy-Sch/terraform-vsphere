output "vm_name" {
  value = vsphere_virtual_machine.vm.name
}

output "vm_ip_address" {
  value = vsphere_virtual_machine.vm.default_ip_address 
}

resource "local_file" "private_key" {
  depends_on      = [tls_private_key.ssh_key]
  content         = tls_private_key.ssh_key.private_key_openssh
  filename        = "${var.vm_name}_${var.vm_ssh_user}_privkey"
  file_permission = "0600"
}

output "ssh_command" { 
  value     = nonsensitive("ssh ${var.vm_ssh_user}@${var.vm_ipv4_address} -i ${var.vm_name}_${var.vm_ssh_user}_privkey")
}
