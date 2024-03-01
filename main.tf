data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vm_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "/${var.vsphere_datacenter}/vm/${var.vsphere_template_folder}/${var.vm_template_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "vsphere_virtual_machine" "vm" {
  name                 = var.vm_name
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id         = data.vsphere_datastore.datastore.id
  num_cpus             = var.vm_cpu
  num_cores_per_socket = var.vm_cores_per_socket
  memory               = var.vm_ram
  guest_id             = var.vm_guest_id
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "${var.vm_name}-disk"
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    size             = var.vm_disk_size == "" ? data.vsphere_virtual_machine.template.disks.0.size : var.vm_disk_size 
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone = var.vm_linked_clone
    customize {
      linux_options {
        host_name       = var.vm_name
        domain		    = var.vm_domain
        time_zone       = var.vm_tz
      }
      network_interface {
        ipv4_address	= var.vm_ipv4_address 
        ipv4_netmask	= var.vm_ipv4_netmask
      }
      ipv4_gateway      = var.vm_ipv4_gateway
      dns_server_list   = var.vm_dns_server_list
      dns_suffix_list   = var.vm_dns_suffix_list
    }
  }
  connection {
    type        = "ssh"
    target_platform = "unix"
    port        = 22
    host        = var.vm_ipv4_address
    user        = var.vm_ssh_user
    private_key = file(var.vm_ssh_user_private_key)
  }
  provisioner "file" {
    source      = "${path.module}/scripts"
    destination = "/tmp/terraform_scripts"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update", 
      "sudo apt dist-upgrade -y" ,
      "sudo chmod u+x /tmp/terraform_scripts/*.sh",
      "/tmp/terraform_scripts/add-public-ssh-key.sh \"${tls_private_key.ssh_key.public_key_openssh}\"",
    ]
  }
}