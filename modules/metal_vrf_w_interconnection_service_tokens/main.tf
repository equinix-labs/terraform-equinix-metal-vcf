provider "equinix" {
  client_id     = var.equinix_client_id
  client_secret = var.equinix_client_secret
  auth_token    = var.metal_auth_token
}

# Provision Metal VRF for VCF Management Domain and VCF Management/Underlay Routing
resource "equinix_metal_vrf" "vcf_vrf" {
  description = "VRF with ASN 65100 and a pool of address space that includes a subnet for your BGP and subnets for each of your Metal Gateways"
  name        = "vcf-vrf"
  metro       = var.metal_metro
  project_id  = var.metal_project_id
  local_asn   = var.metal_vrf_asn
  ip_ranges   = var.metal_vrf_ip_ranges
}

# Create Redundant Interconnection Service Tokens for later consumption from Fabric Portal
resource "equinix_metal_connection" "vcf_vrf_connection_metal" {
  type               = "shared"
  name               = "vcf_vrf_connection"
  metro              = var.metal_metro
  redundancy         = "redundant"
  project_id         = var.metal_project_id
  service_token_type = "z_side"
  vrfs               = [equinix_metal_vrf.vcf_vrf.id, equinix_metal_vrf.vcf_vrf.id]
}

# Enable BGP Dynamic Neighbor function of Metal VRF for BGP Peering from within the Metal Project VLANs
resource "null_resource" "vcf_vrf_bgp_dynamic_neighbor" {
  triggers = {
    vrf_id = equinix_metal_vrf.vcf_vrf.id
  }
  provisioner "local-exec" {
    command     = <<EOM
curl -s https://api.equinix.com/metal/v1/vrfs/$VRF_ID -X PUT -H 'Content-Type: application/json' -H "X-Auth-Token:$AUTH_TOKEN" --data '{"bgp_dynamic_neighbors_enabled": true,"bgp_dynamic_neighbors_export_route_map": true,"bgp_dynamic_neighbors_bfd_enabled": true}'
EOM
    interpreter = ["bash", "-c"]
    environment = {
      VRF_ID     = equinix_metal_vrf.vcf_vrf.id
      AUTH_TOKEN = var.metal_auth_token
    }
  }
  depends_on = [equinix_metal_vrf.vcf_vrf]
}

# Configure BGP Peering Details for Metal VRF Primary Interconnection
resource "null_resource" "vcf_vrf_bgp_pri" {
  triggers = {
    peer_asn    = var.metal_vrf_peer_asn
    subnet      = var.metal_vrf_peer_subnet_pri
    metal_ip    = var.metal_vrf_metal_bgp_peer_pri
    customer_ip = var.metal_vrf_cust_bgp_peer_pri
    md5         = var.metal_vrf_shared_md5_pri
  }
  provisioner "local-exec" {
    command     = <<EOM
curl -s https://api.equinix.com/metal/v1/virtual-circuits/$VC_ID -X PUT -H 'Content-Type: application/json' -H "X-Auth-Token:$AUTH_TOKEN" --data '{"peer_asn":'$PEER_ASN',"subnet":"'$SUBNET'","metal_ip":"'$METAL_IP'","customer_ip":"'$CUSTOMER_IP'","md5":"'$MD5'"}'
EOM
    interpreter = ["bash", "-c"]
    environment = {
      VC_ID       = equinix_metal_connection.vcf_vrf_connection_metal.ports[0].virtual_circuit_ids[0]
      AUTH_TOKEN  = var.metal_auth_token
      PEER_ASN    = var.metal_vrf_peer_asn
      SUBNET      = var.metal_vrf_peer_subnet_pri
      METAL_IP    = var.metal_vrf_metal_bgp_peer_pri
      CUSTOMER_IP = var.metal_vrf_cust_bgp_peer_pri
      MD5         = var.metal_vrf_shared_md5_pri
    }
  }
  depends_on = [equinix_metal_vrf.vcf_vrf]
}

# Configure BGP Peering Details for Metal VRF Primary Interconnection
resource "null_resource" "vcf_vrf_bgp_sec" {
  triggers = {
    peer_asn    = var.metal_vrf_peer_asn
    subnet      = var.metal_vrf_peer_subnet_sec
    metal_ip    = var.metal_vrf_metal_bgp_peer_sec
    customer_ip = var.metal_vrf_cust_bgp_peer_sec
    md5         = var.metal_vrf_shared_md5_sec
  }
  provisioner "local-exec" {
    command     = <<EOM
curl -s https://api.equinix.com/metal/v1/virtual-circuits/$VC_ID -X PUT -H 'Content-Type: application/json' -H "X-Auth-Token:$AUTH_TOKEN" --data '{"peer_asn":'$PEER_ASN',"subnet":"'$SUBNET'","metal_ip":"'$METAL_IP'","customer_ip":"'$CUSTOMER_IP'","md5":"'$MD5'"}'
EOM
    interpreter = ["bash", "-c"]
    environment = {
      VC_ID       = equinix_metal_connection.vcf_vrf_connection_metal.ports[1].virtual_circuit_ids[0]
      AUTH_TOKEN  = var.metal_auth_token
      PEER_ASN    = var.metal_vrf_peer_asn
      SUBNET      = var.metal_vrf_peer_subnet_sec
      METAL_IP    = var.metal_vrf_metal_bgp_peer_sec
      CUSTOMER_IP = var.metal_vrf_cust_bgp_peer_sec
      MD5         = var.metal_vrf_shared_md5_sec
    }
  }
  depends_on = [equinix_metal_vrf.vcf_vrf]
}
