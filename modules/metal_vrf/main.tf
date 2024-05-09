# Provision Metal VRF for VCF Management Domain and Underlay Routing
resource "equinix_metal_vrf" "vcf_vrf" {
  description = "VRF with ASN 65100 and a pool of address space that includes a subnet for your BGP and subnets for each of your Metal Gateways"
  name        = "vcf-vrf"
  metro       = var.metro
  project_id  = var.project_id
  local_asn   = var.metal_asn
  ip_ranges   = var.ip_ranges
}