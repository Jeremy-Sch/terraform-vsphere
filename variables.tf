# VMware vCenter 
variable "vsphere_user" {
  type        = string
  description = "VMware vSphere Username"
  sensitive   = true
}

variable "vsphere_password" {
  type        = string
  description = "VMware vSphere Password"
  sensitive   = true
}

variable "vsphere_vcenter" {
  type        = string
  description = "VMWare vCenter Server FQDN / IP"
  sensitive   = true
}

variable "vsphere_unverified_ssl" {
  type        = bool
  description = "Check if the SSL certificate of the VMware vCenter Server UI has been provided by a trusted Root CA"
  default     = false
}

variable "vsphere_datacenter" {
  type        = string
  description = "VMWare vSphere Datacenter"
}

variable "vsphere_cluster" {
  type        = string
  description = "VMWare vSphere Cluster"
}

variable "vsphere_template_folder" {
  type        = string
  description = "VMware vSphere Template Folder"
}

# Virtual Machine 
variable "vm_name" {
  type        = string
  description = "The name of the vSphere virtual machines and the hostname of the machine"
}

variable "vm_datastore" {
  type        = string
  description = "Datastore to use for the VM"
}

variable "vm_network" {
  type        = string
  description = "Network to use for the VM"
}

variable "vm_linked_clone" {
  type        = bool
  description = "Use linked clone to create the vSphere virtual machine from the template"
  default     = false
}

variable "cpu" {
  type        = number
  description = "Number of vCPU allocated to the VM"
  default     = 2
}

variable "cores_per_socket" {
  type        = number
  description = "Number of Cores per CPU allocated to the VM"
  default     = 1
}

variable "ram" {
  type        = number
  description = "Amount of RAM allocated to the VM"
  default     = 2048
}

variable "disksize" {
  type        = number
  description = "Disk size allocated to the VM (in GB)"
  default     = 30
}

variable "vm_guest_id" {
  type        = string
  description = "The vCenter GuestOS ID, which determines the operating system type"
}

variable "vm_template_name" {
  type        = string
  description = "The template used to create the VM"
}

variable "vm_domain" {
  type        = string
  description = "The domain name for the host. This, along with host_name, make up the FQDN of the VM"
  nullable    = true
}

variable "dns_server_list" {
  type        = list(string)
  description = "List of DNS servers"
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "dns_suffix_list" {
  type        = list(string)
  description = "List of DNS search domains"
  nullable    = true
  default     = ["home.lab"]
}

variable "ipv4_address" {
  type        = string
  description = "Define the IPv4 Address for the VM"
}

variable "ipv4_gateway" {
  type        = string
  description = "Define the IPv4 Gateway for the VM"  
}

variable "ipv4_netmask" {
  type        = number
  description = "Define the IPv4 Netmask for the VM. Use the CIDR notation"
  default     = 24
}

variable "ssh_username" {
  type      = string
  sensitive = true
}

variable "public_key" {
  type        = string
  description = "Specify the path to the public key file. The content will be added to the authorized_keys file of the ssh user into the VM"
}

variable "private_key" { 
  type = string 
  description = "Specify the path to the private key file. This will be used to complete post-deployment tasks"
}

variable "vm_tz" {
  type      = string
  description = "Sets the time zone"
  sensitive = true
  default = "Europe/Paris"
}
