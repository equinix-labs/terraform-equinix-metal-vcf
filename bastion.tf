# Creates an Ubuntu Linux bastion host
# Users are expected to use this host as an ssh jump host to access other VCF hosts on the private VLANs
# This host also provides DNS and NTP services and acts as an internet gateway for the VCF hosts.

resource "equinix_metal_device" "bastion" {
  project_id = var.metal_project_id
  hostname   = "bastion"

  user_data = templatefile("${path.module}/templates/bastion-userdata.tmpl", {
    bastion_vlan_id = var.vcf_vrf_networks["bastion"].vlan_id,
    address         = cidrhost(var.vcf_vrf_networks["bastion"].subnet, 2),
    netmask         = cidrnetmask(var.vcf_vrf_networks["bastion"].subnet),
    gateway_address = cidrhost(var.vcf_vrf_networks["bastion"].subnet, 1),
    domain          = var.esxi_domain
  })

  operating_system    = "ubuntu_24_04"
  plan                = var.bastion_plan
  metro               = var.metro
  project_ssh_key_ids = [module.ssh.equinix_metal_ssh_key_id]

}

resource "equinix_metal_port" "bastion_bond0" {
  depends_on      = [equinix_metal_device.bastion]
  port_id         = [for p in equinix_metal_device.bastion.ports : p.id if p.name == "bond0"][0]
  layer2          = false
  bonded          = true
  vlan_ids        = [module.metal_vrf_gateways_w_dynamic_neighbor["bastion"].vlan_uuid]
  reset_on_delete = true
}

module "ssh" {
  source     = "./modules/ssh/"
  project_id = var.metal_project_id
}

resource "equinix_metal_bgp_session" "bastion_bgp" {
  device_id      = equinix_metal_device.bastion.id
  address_family = "ipv4"
}
