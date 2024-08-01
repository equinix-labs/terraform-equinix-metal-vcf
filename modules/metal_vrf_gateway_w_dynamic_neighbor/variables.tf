variable "metal_auth_token" {
    type = string
}
variable "metal_project_id" {
    type = string
}
variable "vrfgw_metro" {
    type = string
}
variable "vrfgw_vxlan_id"{
    type = string
}
variable "vrfgw_vlan_name" {
    type = string
}
variable "vrfgw_subnet" {
    type = string
}
variable "vrf_id" {
    type = string
}
variable "vrfgw_enable_dynamic_neighbor" {
    type = bool
}
variable "vrfgw_dynamic_neighbor_range" {
    type = string
}
variable "vrfgw_dynamic_neighbor_asn" {
    type = string 
}