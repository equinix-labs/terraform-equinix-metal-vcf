# Creates a Windows Management host
# Users are expected to RDP to this host in order to access the various VCF cluster web interfaces.

resource "random_password" "management" {
  length = 16
}

resource "equinix_metal_device" "management" {
  project_id = var.metal_project_id
  hostname   = var.management_name

  operating_system    = "windows_2022"
  plan                = var.management_plan
  metro               = var.metro
  project_ssh_key_ids = [module.ssh.equinix_metal_ssh_key_id]

  user_data = templatefile("${path.module}/templates/management-userdata.tmpl", {
    bastion_vlan_id   = var.vcf_vrf_networks["bastion"].vlan_id
    bastion_address   = var.bastion_ip
    address           = var.management_ip
    prefix            = split("/", var.vcf_vrf_networks["bastion"].subnet)[1]
    gateway_address   = cidrhost(var.vcf_vrf_networks["bastion"].subnet, 1)
    admin_password    = random_password.management.result
    route_destination = var.esxi_network_space
    domain            = var.zone_name
  })
}
resource "equinix_metal_port" "management_bond0" {
  depends_on      = [equinix_metal_device.management]
  port_id         = [for p in equinix_metal_device.management.ports : p.id if p.name == "bond0"][0]
  layer2          = false
  bonded          = true
  vlan_ids        = [module.metal_vrf_gateways_w_dynamic_neighbor["bastion"].vlan_uuid]
  reset_on_delete = true
}
