variable "vsphere_vcenter" {
  description = "vSphere vCenter Server IP or FQDN"
  type        = string
}

variable "vsphere_user" {
  description = "vSphere username"
  type        = string
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
}

variable "vsphere_datacenter" {
  description = "Name of the vSphere datacenter"
  type        = string
}

variable "vsphere_datastore" {
  description = "Name of the vSphere datastore"
  type        = string
}

variable "vsphere_cluster" {
  description = "Name of the vSphere cluster"
  type        = string
}

variable "vsphere_network" {
  description = "Name of the vSphere network"
  type        = string
}

variable "vm_template_name" {
  description = "Name of the VM template to use"
  type        = string
}

variable "vm_cpu_nos" {
  description = "Number of CPUs for the VM"
  type        = number
}

variable "vm_mem_size" {
  description = "Memory size (in MB) for the VM"
  type        = number
}

variable "vm_disk_size" {
  description = "Disk size (in GB) for the VM"
  type        = number
}

variable "vm_count" {
  description = "Number of VMs"
  type        = number
}

variable "vm_name" {
  description = "Name prefix for VM"
  type        = string
}

variable "vm_disk_label" {
  description = "Label for VM"
  type        = string
}


