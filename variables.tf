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
  description = "The name of the vSphere virtual machine and the hostname of the machine"
}

variable "vm_datastore" {
  type        = string
  description = "The name of the VMware vSphere Datastore where the virtual machine will be stored"
}

variable "vm_network" {
  type        = string
  description = "The name of the VMware vSphere Network to which the virtual machine will be connected"
}

variable "vm_linked_clone" {
  type        = bool
  description = "Indicates whether to use a linked clone to create the vSphere virtual machine from the template"
  default     = false
}

variable "vm_cpu" {
  type        = number
  description = "Number of vCPU allocated to the VM"
  default     = 2
}

variable "vm_cores_per_socket" {
  type        = number
  description = "Number of cores per CPU socket allocated to the VM"
  default     = 1
}

variable "vm_ram" {
  type        = number
  description = "Amount of RAM allocated to the VM (in MB)"
  default     = 2048
}

variable "vm_disk_size" {
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
  description = "The name of the template used to create the virtual machine in VMware vSphere"
}

variable "vm_domain" {
  type        = string
  description = "The domain name for the host. This, along with vm_name, make up the FQDN of the VM"
  nullable    = true
}

variable "vm_dns_server_list" {
  type        = list(string)
  description = "A list of DNS servers to be configured for the virtual machine"
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "vm_ipv4_address" {
  type        = string
  description = "The IPv4 address to be assigned to the virtual machine"
}

variable "vm_ipv4_gateway" {
  type        = string
  description = "The IPv4 gateway address for the virtual machine"
}

variable "vm_ipv4_netmask" {
  type        = number
  description = "The IPv4 netmask for the virtual machine, specified in CIDR notation"
  default     = 24
}

variable "vm_organization" {
  type        = string
  description = "The organization or entity responsible for managing the virtual machine"
}

variable "vm_domain_admin_user" {
  type        = string
  sensitive   = true
  description = "The username of the domain administrator account for joining the Windows virtual machine to the Active Directory domain"
}

variable "vm_domain_admin_password" {
  type        = string
  sensitive   = true
  description = "The password for the domain administrator account used to join the Windows virtual machine to the Active Directory domain"
}

variable "vm_tz" {
  type        = number
  description = "Sets the time zone for the virtual machine"
  default     = 105 # Europe/Paris
}

variable "vm_password" {
  type        = string
  sensitive   = true
  description = "The password for the Windows virtual machine's local administrator account."
}

