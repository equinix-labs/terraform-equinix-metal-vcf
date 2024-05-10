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
  ip_ranges = [for r in var.vcf_vrf_networks : "${r.subnet}"]
}

module "metal_vlan_gateways" {
  source = "./modules/metal_vlan_gateway"
  project_id = var.project_id
  metro = var.metro
  vrf_id = module.metal_vrf.vrf_id
  for_each = var.vcf_vrf_networks
  vxlan = each.key
  vlan_name = each.value.vlan_name
  subnet = each.value.subnet  
}

module "vcf_metal_devices" {
  source = "./modules/vcf_metal_device"
  project_id = var.project_id
  device_plan = var.esxi_size
  assigned_vlans = [for r in module.metal_vlan_gateways: "${r.vlan_uuid}"]
  for_each = var.esxi_devices
  metro = var.metro
  esxi_dns = var.esxi_dns
  esxi_domain = var.esxi_domain
  esxi_gateway = var.esxi_gateway
  esxi_ip = each.value.mgmt_ip
  esxi_mgmtvlan = var.esxi_mgmtvlan
  esxi_name = each.key
  esxi_ntp = var.esxi_ntp
  esxi_pw = var.esxi_pw
  esxi_subnet = var.esxi_subnet
  esxi_version = var.esxi_version
}
