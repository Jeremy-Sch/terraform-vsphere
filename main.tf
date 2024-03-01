terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
  required_version = ">= 0.13"
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_vcenter
  allow_unverified_ssl = var.vsphere_unverified_ssl
}

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

resource "vsphere_virtual_machine" "vm" {
  name                 = var.vm_name
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id         = data.vsphere_datastore.datastore.id
  num_cpus             = var.cpu
  num_cores_per_socket = var.cores_per_socket
  memory               = var.ram
  guest_id             = var.vm_guest_id
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "${var.vm_name}-disk"
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    size             = var.disksize == "" ? data.vsphere_virtual_machine.template.disks.0.size : var.disksize 
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name       = var.vm_name
        domain		= var.vm_domain
        time_zone       = var.vm_tz
      }
      network_interface {
        ipv4_address	= var.ipv4_address 
        ipv4_netmask	= var.ipv4_netmask
      }
      ipv4_gateway      = var.ipv4_gateway
      dns_server_list   = var.dns_server_list
      dns_suffix_list   = var.dns_suffix_list
    }
  }
}

resource "null_resource" "post_vm_creation_tasks" {
  depends_on = [vsphere_virtual_machine.vm]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update", 
      "sudo apt dist-upgrade -y"    
    ]
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.private_key)
      host        = var.ipv4_address
    }
  }
  triggers = {
    network_is_ready = vsphere_virtual_machine.vm.default_ip_address
  }
}
