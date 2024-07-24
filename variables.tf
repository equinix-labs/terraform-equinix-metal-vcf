variable "auth_token" {
    type = string
}
variable "client_id" {
    type = string
}
variable "client_secret" {
    type = string
}
variable "primary_ne_device_uuid" {
    type = string
}
variable "secondary_ne_device_uuid" {
    type = string
}
variable "ne_device_port" {
    type = number
}
variable "vrf_interconnection_speed" {
    type = number
}
variable "vrf_interconnection_notification_email" {
    type = string
}
variable "vrf_peer_subnet" {
  type = string
  description = "Combine Peering Subnets for Metal VRF Primary Interconnections (/29 minimum)"
}
variable "vrf_peer_asn" {
  type = string
  description = "Customer side BGP ASN for Metal VRF Interconnections"
}
variable "vrf_peer_subnet-pri" {
  type = string
  description = "Peering Subnet for Metal VRF Primary Interconnection"
}
variable "vrf_bgp_customer_peer_ip-pri" {
  type = string
  description = "Customer side BGP Peering IP for Metal VRF Primary Interconnection"
}
variable "vrf_bgp_metal_peer_ip-pri" {
  type = string
  description = "Metal VRF side BGP Peering IP for Metal VRF Primary Interconnection"
}
variable "vrf_bgp_md5-pri" {
  type = string
  description = "Shared Key for BGP MD5 Authentication"
}
variable "vrf_peer_subnet-sec" {
  type = string
  description = "Peering Subnet for Metal VRF Primary Interconnection"
}
variable "vrf_bgp_customer_peer_ip-sec" {
  type = string
  description = "Customer side BGP Peering IP for Metal VRF Primary Interconnection"
}
variable "vrf_bgp_metal_peer_ip-sec" {
  type = string
  description = "Metal VRF side BGP Peering IP for Metal VRF Primary Interconnection"
}
variable "vrf_bgp_md5-sec" {
  type = string
  description = "Shared Key for BGP MD5 Authentication"
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
variable "vcf_vrf_mgmt_overlay_networks" {
    type = map(object({
        vlan_id = string
        vlan_name = string
        subnet = string
    }))
}
variable "vcf_vrf_nsxt_uplinks" {
    type = map(object({
        vlan_id = string
        vlan_name = string
        subnet = string
        dyn_nei_range = string
    }))
}
variable "nsxt_edge_asn" {
    type = string
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