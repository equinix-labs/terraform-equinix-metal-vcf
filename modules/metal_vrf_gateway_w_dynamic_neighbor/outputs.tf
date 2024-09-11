output "vlan_uuid" {
  description = "VLAN ID of the Metal Gateway created for use with Metal VRF"
  value       = equinix_metal_vlan.vlan.id
}
