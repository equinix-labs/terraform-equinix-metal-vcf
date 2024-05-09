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