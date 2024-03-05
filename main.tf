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

resource "random_password" "password" {
  length           = 24
  special          = true
  numeric          = true
  lower            = true
  upper            = true
  min_special      = 1
  min_numeric      = 1
  min_lower        = 1
  min_upper        = 1
  override_special = "!#$%&*=+:?"
}

resource "vsphere_virtual_machine" "vm" {
  name                 = var.vm_name
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id         = data.vsphere_datastore.datastore.id
  num_cpus             = var.vm_cpu
  num_cores_per_socket = var.vm_cores_per_socket
  memory               = var.vm_ram
  guest_id             = var.vm_guest_id
  firmware             = "efi"
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
    linked_clone  = var.vm_linked_clone
    customize {
      windows_options {
        computer_name         = var.vm_name
        admin_password        = var.vm_password == "" ? random_password.password.result : var.vm_password
        join_domain           = var.vm_domain
        domain_admin_user     = var.vm_domain_admin_user
        domain_admin_password = var.vm_domain_admin_password
        auto_logon            = true
        auto_logon_count      = 1
        time_zone             = var.vm_tz
        organization_name     = var.vm_organization
        run_once_command_list = [
          "cmd.exe /C gpupdate /force"
        ]
      }
      network_interface {
        ipv4_address    = var.vm_ipv4_address
        ipv4_netmask    = var.vm_ipv4_netmask
        dns_server_list = var.vm_dns_server_list
      }
      ipv4_gateway = var.vm_ipv4_gateway
    }
  }
}
