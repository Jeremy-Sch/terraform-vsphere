# Terraform VMware vSphere Linux Virtual Machine Deployment

This Terraform project is designed to deploy linux virtual machines on VMware vSphere. It includes configurations for vCenter, virtual machine settings, and customization options.

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/) installed
- Access to a VMware vSphere environment
- Required credentials and permissions for vCenter

## Project Structure

- `main.tf`: Main configuration file containing the infrastructure setup.
- `variables.tf`: Declaration of variables used in the project.
- `output.tf`: Configuration for output values.
- `terraform.tfvars`: Variable values specific to your environment.
- `vsphere.tfvars`: Variable values for vSphere configuration.

## Variables

### VMware vCenter

- `vsphere_user`: VMware vSphere Username
- `vsphere_password`: VMware vSphere Password
- `vsphere_vcenter`: VMWare vCenter Server FQDN / IP
- `vsphere_unverified_ssl`: Check if the SSL certificate of the VMware vCenter Server UI has been provided by a trusted Root CA (Default: `false`)
- `vsphere_datacenter`: VMWare vSphere Datacenter
- `vsphere_cluster`: VMWare vSphere Cluster
- `vsphere_template_folder`: VMware vSphere Template Folder

### Virtual Machine

- `vm_name`: The name of the vSphere virtual machine and the hostname of the machine
- `vm_datastore`: The name of the VMware vSphere Datastore where the virtual machine will be stored
- `vm_network`: The name of the VMware vSphere Network to which the virtual machine will be connected
- `vm_linked_clone`: Indicates whether to use a linked clone to create the vSphere virtual machine from the template (Default: `false`)
- `vm_cpu`: Number of vCPU allocated to the VM (Default: `2`)
- `vm_cores_per_socket`: Number of cores per CPU socket allocated to the VM (Default: `1`)
- `vm_ram`: Amount of RAM allocated to the VM (in MB) (Default: `2048`)
- `vm_disk_size`: Disk size allocated to the VM (in GB) (Default: `30`)
- `vm_guest_id`: The vCenter GuestOS ID, which determines the operating system type
- `vm_template_name`: The name of the template used to create the virtual machine in VMware vSphere
- `vm_domain`: The domain name for the host. This, along with `vm_name`, makes up the FQDN of the VM (Nullable)
- `vm_dns_server_list`: A list of DNS servers to be configured for the virtual machine (Default: `["8.8.8.8", "8.8.4.4"]`)
- `vm_dns_suffix_list`: A list of DNS suffixes to be configured for the virtual machine (Nullable)
- `vm_ipv4_address`: The IPv4 address to be assigned to the virtual machine
- `vm_ipv4_gateway`: The IPv4 gateway address for the virtual machine
- `vm_ipv4_netmask`: The IPv4 netmask for the virtual machine, specified in CIDR notation (Default: `24`)
- `vm_ssh_user`: The SSH username used for connecting to the virtual machine during provisioning
- `vm_ssh_user_private_key`: The path to the private key file used for SSH authentication to the virtual machine during provisioning
- `vm_tz`: Sets the time zone for the virtual machine (Default: `Europe/Paris`)

## Usage

1. Clone the repository.
2. Navigate to the project directory.
3. Run `terraform init` to initialize the project.
4. Create a `terraform.tfvars` file and fill in the required variable values.
5. Run `terraform apply` to deploy the infrastructure.

## Outputs

- Once deployed, the project provides output values such as VM name and IP address.

