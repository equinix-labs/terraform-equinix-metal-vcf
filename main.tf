terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
      version = "1.35.0"
    }
  }
}


module "metal_vrf" {
  source = "./modules/metal_vrf"
  project_id = var.project_id
  metro = var.metro
  metal_asn = var.metal_vrf_asn
  ip_ranges = [for r in vcf_vrf_networks : "${r.subnet}"]
}

module "vcf_metal_device" {
  source = "./modules/vcf_metal_device"
  project_id = var.project_id
  device_plan = var.esxi_size
  assigned_vlans = [for r in vcf_vrf_networks : "${r.vlan_id}"]
  for_each = var.esxi_devices
  metro = var.metro
  esxi_dns = var.esxi_dns
  esxi_domain = var.esxi_domain
  esxi_gateway = var.esxi_gateway
  esxi_ip = each.mgmt_ip
  esxi_mgmtvlan = esxi_mgmtvlan
  esxi_name = each.name
  esxi_ntp = var.esxi_ntp
  esxi_pw = var.esxi_pw
  esxi_subnet = var.esxi_subnet
  esxi_version = var.esxi_version
}
