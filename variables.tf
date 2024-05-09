variable "auth_token" {
    type = string
}
variable "project_id" {
    type = string
}
variable "metro" {
    type = string
}
variable "billing_cycle" {
    type = string
}
variable "metal_vrf_asn" {
    type = string
}
variable "vcf_vrf_networks" {
    type = map(object({
        vlan_id = string
        vlan_name = string
        subnet = string
    }))
}
variable "esxi_devices" {
    type = map(object({
        name = string
        mgmt_ip = string
    }))
}
variable "esxi_version" {
    type = string
}
variable "esxi_pw" {
    type = string
}
variable "esxi_size" {
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