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

locals {
  templatevars = {
    name         = var.vm_name,
    ipv4_address = var.ipv4_address,
    ipv4_gateway = var.ipv4_gateway,
    ipv4_netmask = var.ipv4_netmask,
    dns_server_1 = var.dns_server_list[0],
    dns_server_2 = var.dns_server_list[1],
    dns_search_domain = var.dns_search_domain,
    public_key = file(var.public_key),
    ssh_username = var.ssh_username
  }
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
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
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
  #cdrom {
    #client_device = true
  #}
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name       = var.vm_name
        domain		= var.vm_domain
        time_zone       = var.vm_tz
        script_text     = file("./templates/customization_script.sh") 
      }
      network_interface {
        ipv4_address	= var.ipv4_address 
        ipv4_netmask	= var.ipv4_netmask
      }
      ipv4_gateway      = var.ipv4_gateway
      dns_server_list   = var.dns_server_list
      dns_suffix_list   = [var.dns_search_domain]
    }
  }
  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("./templates/metadata.yaml", local.templatevars))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(templatefile("./templates/userdata.yaml", local.templatevars))
    "guestinfo.userdata.encoding" = "base64"
  }
  #lifecycle {
    #ignore_changes = [
      #annotation,
      #clone[0].template_uuid,
      #clone[0].customize[0].dns_server_list,
      #clone[0].customize[0].network_interface[0]
    #]
  #}
}
