variable "metal_auth_token" {
    type = string
    description = "API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/"
}
variable "metal_project_id" {
    type = string
    description = "Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles"
}
variable "vrfgw_metro" {
    type = string
    description = "Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference"
}
variable "vrfgw_vxlan_id"{
    type = string
    description = "Metal VLAN ID (802.1q ie. 2-3999) to be created for use with Metal VRF Gateway"
}
variable "vrfgw_vlan_name" {
    type = string
    description = "Description to associate with Metal VLAN being created for use use Metal VRF Gateway"
}
variable "vrfgw_subnet" {
    type = string
    description = "/29 or larger network subnet to be used for Metal VRF Gateway. Note: first usable IP in the specified range will be claimed by the Metal VRF Gateway itself"
}
variable "vrf_id" {
    type = string
    description = "UUID of VRF parent of the Metal VRF Gateway to be created"
}
variable "vrfgw_enable_dynamic_neighbor" {
    type = bool
    description = "Whether or not to configure BGP Dynamic Neighbor range on the created Metal VRF Gateway"
}
variable "vrfgw_dynamic_neighbor_range" {
    type = string
    description = "/31 IP Range of BGP Neighbors that will peer with the created Metal VRF Gateway"
}
variable "vrfgw_dynamic_neighbor_asn" {
    type = string 
    description = "ASN of the BGP Neighbors that will peer with the created Metal VRF Gateway"
}