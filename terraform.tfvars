# VMware vCenter
vsphere_user              = "your_vsphere_username"
vsphere_password          = "your_vsphere_password"
vsphere_vcenter           = "your_vsphere_vcenter_address"
vsphere_unverified_ssl    = false
vsphere_datacenter        = "your_vsphere_datacenter"
vsphere_cluster           = "your_vsphere_cluster"
vm_datastore              = "your_vm_datastore"
vsphere_template_folder   = "your_template_folder"
vm_template_name          = "your_vm_template_name"

# Virtual Machine
vm_name                   = "your_vm_name"
vm_network                = "your_vm_network"
vm_linked_clone           = false
vm_cpu                    = 2
vm_cores_per_socket       = 1
vm_ram                    = 2048
vm_disk_size              = 30
vm_guest_id               = "your_vm_guest_id"
vm_domain                 = "your_vm_domain"  # Set to null if not applicable
vm_dns_server_list        = ["8.8.8.8", "8.8.4.4"]
vm_dns_suffix_list        = ["your_dns_suffix"]  # Set to null if not applicable
vm_ipv4_address           = "your_vm_ipv4_address"
vm_ipv4_gateway           = "your_vm_ipv4_gateway"
vm_ipv4_netmask           = 24
vm_ssh_user               = "your_ssh_username"
vm_ssh_user_private_key   = "your_ssh_private_key_file"
vm_tz                     = "your_timezone"
