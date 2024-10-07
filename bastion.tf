# Creates an Ubuntu Linux bastion host
# Users are expected to use this host as an ssh jump host to access other VCF hosts on the private VLANs
# This host also provides DNS and NTP services and acts as an internet gateway for the VCF hosts.

resource "equinix_metal_device" "bastion" {
  project_id = var.metal_project_id
  hostname   = var.bastion_name

  user_data = templatefile("${path.module}/templates/bastion-userdata.tmpl", {
    hostname          = var.bastion_name
    bastion_vlan_id   = var.vcf_vrf_networks["bastion"].vlan_id
    address           = var.bastion_ip
    netmask           = cidrnetmask(var.vcf_vrf_networks["bastion"].subnet)
    gateway_address   = cidrhost(var.vcf_vrf_networks["bastion"].subnet, 1)
    zone_name         = var.zone_name
    esx01_name        = var.esxi_devices["esx01"].name
    esx01_ip          = var.esxi_devices["esx01"].mgmt_ip
    esx02_name        = var.esxi_devices["esx02"].name
    esx02_ip          = var.esxi_devices["esx02"].mgmt_ip
    esx03_name        = var.esxi_devices["esx03"].name
    esx03_ip          = var.esxi_devices["esx03"].mgmt_ip
    esx04_name        = var.esxi_devices["esx04"].name
    esx04_ip          = var.esxi_devices["esx04"].mgmt_ip
    vcenter_name      = var.vcenter_name
    vcenter_ip        = var.vcenter_ip
    nsx_vip_name      = var.nsx_devices["vip"].name
    nsx_vip_ip        = var.nsx_devices["vip"].ip
    nsx_node_1_name   = var.nsx_devices["node1"].name
    nsx_node_1_ip     = var.nsx_devices["node1"].ip
    nsx_node_2_name   = var.nsx_devices["node2"].name
    nsx_node_2_ip     = var.nsx_devices["node2"].ip
    nsx_node_3_name   = var.nsx_devices["node3"].name
    nsx_node_3_ip     = var.nsx_devices["node3"].ip
    sddc_manager_name = var.sddc_manager_name
    sddc_manager_ip   = var.sddc_manager_ip
    cloudbuilder_name = var.cloudbuilder_name
    cloudbuilder_ip   = var.cloudbuilder_ip
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
