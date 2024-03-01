output "vm_name" {
  value = vsphere_virtual_machine.vm.name
}

output "vm_ip_address" {
  value = vsphere_virtual_machine.vm.default_ip_address 
}

output "exported_private_key" {
  value = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

resource "null_resource" "save_private_key" {
  depends_on = [tls_private_key.ssh_key]
  triggers = {
    private_key = tls_private_key.ssh_key.private_key_pem
  }
  provisioner "local-exec" {
    command = <<-EOT
      echo "${null_resource.save_private_key.triggers.private_key}" > exported_keys/${var.vm_name}_${var.vm_ssh_user}_privkey.pem
    EOT
  }
}



