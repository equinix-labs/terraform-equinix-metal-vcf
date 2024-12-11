# Deploy Metal VRF, Enable BGP Dynamic Neighbor function of VRF, Create Fabric Interconnection Service Tokens
# and configure BGP Peering Details on VRF Interconnections
module "metal_vrf" {
  source                       = "./modules/metal_vrf_w_interconnection_service_tokens"
  metal_auth_token             = var.metal_auth_token
  metal_project_id             = var.metal_project_id
  metal_metro                  = var.metro
  metal_vrf_asn                = var.metal_vrf_asn
  metal_vrf_peer_asn           = var.vrf_peer_asn
  metal_vrf_ip_ranges          = concat([var.vrf_peer_subnet], [for r in var.vcf_vrf_networks : r.subnet if r.subnet != ""])
  metal_vrf_peer_subnet_pri    = var.vrf_peer_subnet_pri
  metal_vrf_peer_subnet_sec    = var.vrf_peer_subnet_sec
  metal_vrf_metal_bgp_peer_pri = var.vrf_bgp_metal_peer_ip_pri
  metal_vrf_metal_bgp_peer_sec = var.vrf_bgp_metal_peer_ip_sec
  metal_vrf_cust_bgp_peer_pri  = var.vrf_bgp_customer_peer_ip_pri
  metal_vrf_cust_bgp_peer_sec  = var.vrf_bgp_customer_peer_ip_sec
  metal_vrf_shared_md5_pri     = var.vrf_bgp_md5_pri
  metal_vrf_shared_md5_sec     = var.vrf_bgp_md5_sec
}

# Deploy Metal VLANs and associated VRF Gateways with optional BGP Dynamic Neighbor details
module "metal_vrf_gateways_w_dynamic_neighbor" {
  source                        = "./modules/metal_vrf_gateway_w_dynamic_neighbor"
  metal_auth_token              = var.metal_auth_token
  metal_project_id              = var.metal_project_id
  vrfgw_metro                   = var.metro
  vrf_id                        = module.metal_vrf.vrf_id
  for_each                      = var.vcf_vrf_networks
  vrfgw_vxlan_id                = each.value.vlan_id
  vrfgw_vlan_name               = each.value.vlan_name
  vrfgw_subnet                  = each.value.subnet
  vrfgw_enable_dynamic_neighbor = each.value.enable_dyn_nei
  vrfgw_dynamic_neighbor_range  = each.value.dyn_nei_range
  vrfgw_dynamic_neighbor_asn    = each.value.dyn_nei_asn
}

# Deploy ESXi Metal Instances with basic config required for Cloudbuilder
module "vcf_metal_devices" {
  source                  = "./modules/vcf_metal_device"
  metal_project_id        = var.metal_project_id
  metal_device_plan       = var.esxi_plan
  esxi_assigned_vlans     = [for r in module.metal_vrf_gateways_w_dynamic_neighbor : r.vlan_uuid]
  for_each                = var.esxi_devices
  metal_metro             = var.metro
  esxi_dns_server         = var.bastion_ip
  esxi_domain             = var.zone_name
  esxi_management_gateway = var.esxi_management_gateway
  esxi_management_ip      = each.value.mgmt_ip
  esxi_mgmt_vlan          = var.vcf_vrf_networks["mgmt"].vlan_id
  vm_mgmt_vlan            = var.vcf_vrf_networks["vm-mgmt"].vlan_id
  esxi_hostname           = each.value.name
  esxi_ntp_server         = var.bastion_ip
  esxi_password           = var.esxi_password
  esxi_management_subnet  = var.esxi_management_subnet
  esxi_version_slug       = var.esxi_version_slug
  esxi_reservation_id     = each.value.reservation_id
}

# Create Fabric VC Service Tokens for NSX-T Uplink VLANs
resource "equinix_metal_connection" "nsxt_uplink_connection_metal" {
  type               = "shared"
  name               = "nsx-t_uplink_connection"
  metro              = var.metro
  redundancy         = "redundant"
  project_id         = var.metal_project_id
  service_token_type = "z_side"
  vlans              = [var.vcf_vrf_networks["NSXt_Uplink1"].vlan_id, var.vcf_vrf_networks["NSXt_Uplink2"].vlan_id]
  depends_on         = [module.metal_vrf_gateways_w_dynamic_neighbor]
}