terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
      version = "1.35.0"
    }
  }
}

provider "equinix" {
  client_id     = var.client_id
  client_secret = var.client_secret
  auth_token    = var.auth_token
}

module "metal_vrf" {
  source = "./modules/metal_vrf"
  auth_token = var.auth_token
  project_id = var.project_id
  metro = var.metro
  primary_ne_device_uuid = var.primary_ne_device_uuid
  secondary_ne_device_uuid = var.secondary_ne_device_uuid
  ne_device_port = var.ne_device_port
  interconnection_speed = var.vrf_interconnection_speed
  interconnection_notification_email = var.vrf_interconnection_notification_email
  peer_subnet = var.vrf_peer_subnet
  metal_asn = var.metal_vrf_asn
  peer_asn = var.vrf_peer_asn
  ip_ranges = concat([var.vrf_peer_subnet],[for r in var.vcf_vrf_mgmt_overlay_networks : "${r.subnet}"],[for r in var.vcf_vrf_nsxt_uplinks : "${r.subnet}"])
  peer_subnet-pri = var.vrf_peer_subnet-pri
  peer_subnet-sec = var.vrf_peer_subnet-sec
  metal_bgp_peer-pri = var.vrf_bgp_metal_peer_ip-pri
  metal_bgp_peer-sec = var.vrf_bgp_metal_peer_ip-sec
  cust_bgp_peer-pri = var.vrf_bgp_customer_peer_ip-pri
  cust_bgp_peer-sec = var.vrf_bgp_customer_peer_ip-sec
  shared_md5-pri = var.vrf_bgp_md5-pri
  shared_md5-sec = var.vrf_bgp_md5-sec
}

module "metal_vlan_gateways" {
  source = "./modules/metal_vlan_gateway"
  auth_token = var.auth_token
  project_id = var.project_id
  metro = var.metro
  vrf_id = module.metal_vrf.vrf_id
  for_each = var.vcf_vrf_mgmt_overlay_networks
  vxlan = each.key
  vlan_name = each.value.vlan_name
  subnet = each.value.subnet  
}

module "metal_vlan_gateways_w_dynamic_neighbor" {
  source = "./modules/metal_vlan_gateway_w_dynamic_neighbor"
  auth_token = var.auth_token
  project_id = var.project_id
  metro = var.metro
  vrf_id = module.metal_vrf.vrf_id
  for_each = var.vcf_vrf_nsxt_uplinks
  vxlan = each.key
  vlan_name = each.value.vlan_name
  subnet = each.value.subnet
  vrf_dynamic_neighbor_range = each.value.dyn_nei_range
  vrf_dynamic_neighbor_asn = var.nsxt_edge_asn
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
