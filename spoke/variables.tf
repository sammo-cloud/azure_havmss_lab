variable "location" {
}

variable "application_port" {
   description = "The port that you want to expose to the external load balancer"
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM Scale Set"
}

variable "admin_password" {
   description = "Default password for admin account"
}

variable "client_secret" {
}

variable "client_id" {
}

variable "tenant_id" {
}

variable "subscription_id" {
}

variable "rg_ha_name"{
}

variable "rg_vmss_name" {
}

variable "rg_spoke1_name" {
}

variable "rg_spoke2_name" {
}

variable "rg_mgmt_name" {
}

variable "rg_vnet_name" {
}
