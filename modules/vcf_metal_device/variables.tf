variable "project_id" {
    type = string
}
variable "metro" {
    type = string
}
variable "billing_cycle" {
    type = string
    default = "hourly"
}
variable "device_plan" {
    type = string
}
variable "esxi_name" {
    type = string
}
variable "esxi_version" {
    type = string
}
variable "esxi_pw" {
    type = string
}
variable "esxi_ip" {
    type = string
}
variable "esxi_gateway" {
    type = string
}
variable "esxi_subnet" {
    type = string
}
variable "esxi_dns" {
    type = string
}
variable "esxi_domain" {
    type = string
}
variable "esxi_mgmtvlan" {
    type = string
}
variable "esxi_ntp" {
    type = string
}
variable "assigned_vlans" {
    type = set(string)
}