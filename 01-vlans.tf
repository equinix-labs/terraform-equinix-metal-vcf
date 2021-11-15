provider "metal" {
  auth_token = var.auth_token
}

# Provision VLANs
resource "metal_vlan" "vlans" {
  count       = length(var.vlans)
  project_id  = var.project_id
  metro       = var.metro
  vxlan       = var.vlans[count.index].vxlan
  description = var.vlans[count.index].name
}
