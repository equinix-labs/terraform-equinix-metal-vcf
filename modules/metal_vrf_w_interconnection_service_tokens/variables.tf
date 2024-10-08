variable "metal_auth_token" {
  type        = string
  description = "API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/"
}
variable "metal_project_id" {
  type        = string
  description = "Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles"
}
variable "metal_metro" {
  type        = string
  description = "Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference"
}
variable "metal_vrf_asn" {
  type        = string
  description = "ASN to be used for Metal VRF https://deploy.equinix.com/developers/docs/metal/networking/vrf/"
}
variable "metal_vrf_ip_ranges" {
  type        = set(string)
  description = "All IP Address Ranges to be used by Metal VRF, including Metal VRF Gateway subnets and Interconnection point to point networks (eg /29 to cover two /30 interconnections)"
}
variable "metal_vrf_peer_asn" {
  type        = string
  description = "ASN that will establish BGP Peering with the Metal VRF across the interconnections"
}
variable "metal_vrf_peer_subnet_pri" {
  type        = string
  description = "Subnet used for point to point Metal VRF BGP Neighbor connection across the Primary interconnection"
}
variable "metal_vrf_cust_bgp_peer_pri" {
  type        = string
  description = "IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with"
}
variable "metal_vrf_metal_bgp_peer_pri" {
  type        = string
  description = "IP of Metal VRF on Primary Interconnection for peering with BGP Neighbor"
}
variable "metal_vrf_shared_md5_pri" {
  type        = string
  description = "MD5 Shared Password for BGP session authentication"
}
variable "metal_vrf_peer_subnet_sec" {
  type        = string
  description = "Subnet used for point to point Metal VRF BGP Neighbor connection across the Secondary interconnection"
}
variable "metal_vrf_cust_bgp_peer_sec" {
  type        = string
  description = "IP of BGP Neighbor on Secondary Interconnection that Metal VRF should expect to peer with"
}
variable "metal_vrf_metal_bgp_peer_sec" {
  type        = string
  description = "IP of Metal VRF on Secondary Interconnection for peering with BGP Neighbor"
}
variable "metal_vrf_shared_md5_sec" {
  type        = string
  description = "MD5 Shared Password for BGP session authentication"
}
