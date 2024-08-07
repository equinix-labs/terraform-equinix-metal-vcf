## Provision VLAN
resource "equinix_metal_vlan" "vlan" {
  project_id  = var.metal_project_id
  metro       = var.vrfgw_metro
  vxlan       = var.vrfgw_vxlan_id
  description = var.vrfgw_vlan_name
}

## Provision Reserved IP Block for VRF Gateway
resource "equinix_metal_reserved_ip_block" "vrf_gateway_ip_block" {
  description = join(" ",["Reserved gateway IP block",var.vrfgw_subnet,"taken from one of the ranges in the VRF's pool of address space ip_ranges."])
  project_id  = var.metal_project_id
  metro       = var.vrfgw_metro
  type        = "vrf"
  vrf_id      = var.vrf_id
  network     = split("/",var.vrfgw_subnet)[0]
  cidr        = split("/",var.vrfgw_subnet)[1]
}

## Provision Metal VRF Gateway for VLAN
resource "equinix_metal_gateway" "vrf_gateway" {
  project_id        = var.metal_project_id
  vlan_id           = equinix_metal_vlan.vlan.id
  ip_reservation_id = equinix_metal_reserved_ip_block.vrf_gateway_ip_block.id
}

## If Dynamic Neighbor Subnet and ASN are specified, configure BGP Dynamic Neighbors on Metal Gateway
resource "null_resource" "vrf-bgp_dynamic_neighbor" {
  count = "${var.vrfgw_enable_dynamic_neighbor ? 1 : 0}" 
  triggers = {
    gateway_uuid = equinix_metal_gateway.vrf_gateway.id
    neighbor_range = var.vrfgw_dynamic_neighbor_range
    neighbor_asn = var.vrfgw_dynamic_neighbor_asn
  }
  provisioner "local-exec" {
    command = <<EOM
curl -s "https://api.equinix.com/metal/v1/metal-gateways/$GATEWAY_UUID/bgp-dynamic-neighbors" -X POST -H "Content-Type: application/json" -H "X-Auth-Token: $AUTH_TOKEN" --data '{"bgp_neighbor_range":"'"$NEIGHBOR_RANGE"'","bgp_neighbor_asn":'"$NEIGHBOR_ASN"'}'
EOM
    interpreter = ["bash", "-c"]
    environment = {
      GATEWAY_UUID = equinix_metal_gateway.vrf_gateway.id
      AUTH_TOKEN = var.metal_auth_token
      NEIGHBOR_RANGE = var.vrfgw_dynamic_neighbor_range
      NEIGHBOR_ASN = var.vrfgw_dynamic_neighbor_asn
    }
  }
  depends_on = [equinix_metal_gateway.vrf_gateway]
}