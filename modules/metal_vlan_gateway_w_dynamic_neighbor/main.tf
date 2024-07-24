# Provision VLAN
resource "equinix_metal_vlan" "vlan" {
  project_id  = var.project_id
  metro       = var.metro
  vxlan       = var.vxlan
  description = var.vlan_name
}

# Provision Reserved IP Block for VRF Gateway
resource "equinix_metal_reserved_ip_block" "vrf_gateway_ip_block" {
  description = join(" ",["Reserved gateway IP block",var.subnet,"taken from one of the ranges in the VRF's pool of address space ip_ranges."])
  project_id  = var.project_id
  metro       = var.metro
  type        = "vrf"
  vrf_id      = var.vrf_id
  network     = split("/",var.subnet)[0]
  cidr        = split("/",var.subnet)[1]
}

# Provision Metal VRF Gateway for VLAN
resource "equinix_metal_gateway" "vrf_gateway" {
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.vlan.id
  ip_reservation_id = equinix_metal_reserved_ip_block.vrf_gateway_ip_block.id
}

resource "null_resource" "vcf_vrf-bgp_dyn_nei-NSXt_Uplink_1" {
  triggers = {
    gateway_uuid = equinix_metal_gateway.vrf_gateway.id
    neighbor_range = var.vrf_dynamic_neighbor_range
    neighbor_asn = var.vrf_dynamic_neighbor_asn
  }
  provisioner "local-exec" {
    command = <<EOM
curl -s "https://api.equinix.com/metal/v1/metal-gateways/$GATEWAY_UUID/bgp-dynamic-neighbors" -X POST -H "Content-Type: application/json" -H "X-Auth-Token: $AUTH_TOKEN" --data '{"bgp_neighbor_range":"'"$NEIGHBOR_RANGE"'","bgp_neighbor_asn":'"$NEIGHBOR_ASN"'}'
EOM
    interpreter = ["bash", "-c"]
    environment = {
      GATEWAY_UUID = equinix_metal_gateway.vrf_gateway.id
      AUTH_TOKEN = var.auth_token
      NEIGHBOR_RANGE = var.vrf_dynamic_neighbor_range
      NEIGHBOR_ASN = var.vrf_dynamic_neighbor_asn
    }
  }
  depends_on = [equinix_metal_gateway.vrf_gateway]
}