terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
      version = ">= 1.35.0"
    }
  }
}

provider "equinix" {
  client_id     = var.fabric_client_id
  client_secret = var.fabric_client_secret
  auth_token    = var.metal_auth_token
}

module "metal_vrf" {
  source = "./modules/metal_vrf_w_interconnection_to_network_edge"
  fabric_client_id = var.fabric_client_id
  fabric_client_secret = var.fabric_client_secret
  metal_auth_token = var.metal_auth_token
  metal_project_id = var.metal_project_id
  metal_metro = var.metro
  primary_ne_device_uuid = var.primary_ne_device_uuid
  secondary_ne_device_uuid = var.secondary_ne_device_uuid
  primary_ne_device_port = var.primary_ne_device_port
  secondary_ne_device_port = var.secondary_ne_device_port
  metal_vrf_interconnection_speed = var.vrf_interconnection_speed
  fabric_interconnection_notification_email = var.vrf_interconnection_notification_email
  metal_vrf_peer_subnet = var.vrf_peer_subnet
  metal_vrf_asn = var.metal_vrf_asn
  metal_vrf_peer_asn = var.vrf_peer_asn
  metal_vrf_ip_ranges = concat([var.vrf_peer_subnet],[for r in var.vcf_vrf_networks : "${r.subnet}"])
  metal_vrf_peer_subnet-pri = var.vrf_peer_subnet-pri
  metal_vrf_peer_subnet-sec = var.vrf_peer_subnet-sec
  metal_vrf_metal_bgp_peer-pri = var.vrf_bgp_metal_peer_ip-pri
  metal_vrf_metal_bgp_peer-sec = var.vrf_bgp_metal_peer_ip-sec
  metal_vrf_cust_bgp_peer-pri = var.vrf_bgp_customer_peer_ip-pri
  metal_vrf_cust_bgp_peer-sec = var.vrf_bgp_customer_peer_ip-sec
  metal_vrf_shared_md5-pri = var.vrf_bgp_md5-pri
  metal_vrf_shared_md5-sec = var.vrf_bgp_md5-sec
}

module "metal_vrf_gateways_w_dynamic_neighbor" {
  source = "./modules/metal_vrf_gateway_w_dynamic_neighbor"
  metal_auth_token = var.metal_auth_token
  metal_project_id = var.metal_project_id
  vrfgw_metro = var.metro
  vrf_id = module.metal_vrf.vrf_id
  for_each = var.vcf_vrf_networks
  vrfgw_vxlan_id = each.key
  vrfgw_vlan_name = each.value.vlan_name
  vrfgw_subnet = each.value.subnet
  vrfgw_enable_dynamic_neighbor = each.value.enable_dyn_nei
  vrfgw_dynamic_neighbor_range = each.value.dyn_nei_range
  vrfgw_dynamic_neighbor_asn = each.value.dyn_nei_asn
}

module "vcf_metal_devices" {
  source = "./modules/vcf_metal_device"
  metal_auth_token = var.metal_auth_token
  metal_project_id = var.metal_project_id
  metal_device_plan = var.esxi_size
  esxi_assigned_vlans = [for r in module.metal_vrf_gateways_w_dynamic_neighbor: "${r.vlan_uuid}"]
  for_each = var.esxi_devices
  metal_metro = var.metro
  esxi_dns_server = var.esxi_dns_server
  esxi_domain = var.esxi_domain
  esxi_management_gateway = var.esxi_management_gateway
  esxi_management_ip = each.value.mgmt_ip
  esxi-mgmt_vlan = var.esxi-mgmt_vlan
  vm-mgmt_vlan = var.vm-mgmt_vlan
  esxi_hostname = each.key
  esxi_ntp_server = var.esxi_ntp_server
  esxi_password = var.esxi_password
  esxi_management_subnet = var.esxi_management_subnet
  esxi_version_slug = var.esxi_version_slug
}