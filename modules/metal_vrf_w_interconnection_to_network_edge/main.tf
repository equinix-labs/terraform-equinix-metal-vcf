provider "equinix" {
  client_id     = var.fabric_client_id
  client_secret = var.fabric_client_secret
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



resource "equinix_metal_connection" "vcf_vrf_connection-metal" {
  type = "shared"
  name = "vcf_vrf_connection"
  metro = var.metal_metro
  redundancy = "redundant"
  project_id = var.metal_project_id
  service_token_type = "z_side"
  vrfs = [equinix_metal_vrf.vcf_vrf.id, equinix_metal_vrf.vcf_vrf.id]
}



resource "equinix_fabric_connection" "vcf_vrf_connection-pri" {
  lifecycle {
    ignore_changes = [ redundancy ]
  }
  name = "vcf_vrf_connection-pri"
  type = "EVPL_VC"
  notifications {
    type   = "ALL"
    emails = [var.fabric_interconnection_notification_email]
  }
  bandwidth = var.metal_vrf_interconnection_speed
  order {
  }
  a_side {
    access_point {
      type = "VD"
      virtual_device {
        type = "EDGE"
        uuid = var.primary_ne_device_uuid
      }
      interface {
        type = "NETWORK"
        id = var.primary_ne_device_port
      }
    }
  }
  z_side {
    service_token {
      uuid = equinix_metal_connection.vcf_vrf_connection-metal.service_tokens[0].id 
    }
  }
}



resource "equinix_fabric_connection" "vcf_vrf_connection-sec" {
  lifecycle {
    ignore_changes = [ redundancy ]
  }
  name = "vcf_vrf_connection-sec"
  type = "EVPL_VC"
  notifications {
    type   = "ALL"
    emails = [var.fabric_interconnection_notification_email]
  }
  bandwidth = var.metal_vrf_interconnection_speed
  order {
  }
  a_side {
    access_point {
      type = "VD"
      virtual_device {
        type = "EDGE"
        uuid = var.secondary_ne_device_uuid
      }
      interface {
        type = "NETWORK"
        id = var.secondary_ne_device_port
      }
    }
  }
  z_side {
    service_token{
      uuid = equinix_metal_connection.vcf_vrf_connection-metal.service_tokens[1].id
    }
  }
}



resource "null_resource" "vcf_vrf_bgp_dynamic_neighbor" {
  triggers = {
    vrf_id = equinix_metal_vrf.vcf_vrf.id
  }
  provisioner "local-exec" {
    command = <<EOM
curl -s https://api.equinix.com/metal/v1/vrfs/$VRF_ID -X PUT -H 'Content-Type: application/json' -H "X-Auth-Token:$AUTH_TOKEN" --data '{"bgp_dynamic_neighbors_enabled": true,"bgp_dynamic_neighbors_export_route_map": true,"bgp_dynamic_neighbors_bfd_enabled": true}'
EOM
    interpreter = ["bash", "-c"]
    environment = {
      VRF_ID = equinix_metal_vrf.vcf_vrf.id
      AUTH_TOKEN = var.metal_auth_token
    }
  }
  depends_on = [equinix_metal_vrf.vcf_vrf]
}



resource "null_resource" "vcf_vrf_bgp-pri" {
  triggers = {
    peer_asn = var.metal_vrf_peer_asn
    subnet = var.metal_vrf_peer_subnet-pri
    metal_ip = var.metal_vrf_metal_bgp_peer-pri
    customer_ip = var.metal_vrf_cust_bgp_peer-pri
    md5 = var.metal_vrf_shared_md5-pri
  }
  provisioner "local-exec" {
    command = <<EOM
curl -s https://api.equinix.com/metal/v1/virtual-circuits/$VC_ID -X PUT -H 'Content-Type: application/json' -H "X-Auth-Token:$AUTH_TOKEN" --data '{"peer_asn":'$PEER_ASN',"subnet":"'$SUBNET'","metal_ip":"'$METAL_IP'","customer_ip":"'$CUSTOMER_IP'","md5":"'$MD5'"}'
EOM
    interpreter = ["bash", "-c"]
    environment = {
      VC_ID = equinix_metal_connection.vcf_vrf_connection-metal.ports[0].virtual_circuit_ids[0]
      AUTH_TOKEN = var.metal_auth_token
      PEER_ASN = var.metal_vrf_peer_asn
      SUBNET = var.metal_vrf_peer_subnet-pri
      METAL_IP = var.metal_vrf_metal_bgp_peer-pri
      CUSTOMER_IP = var.metal_vrf_cust_bgp_peer-pri
      MD5 = var.metal_vrf_shared_md5-pri
    }
  }
  depends_on = [equinix_fabric_connection.vcf_vrf_connection-pri,equinix_metal_vrf.vcf_vrf]
}



resource "null_resource" "vcf_vrf_bgp-sec" {
  triggers = {
    peer_asn = var.metal_vrf_peer_asn
    subnet = var.metal_vrf_peer_subnet-sec
    metal_ip = var.metal_vrf_metal_bgp_peer-sec
    customer_ip = var.metal_vrf_cust_bgp_peer-sec
    md5 = var.metal_vrf_shared_md5-sec
  }
  provisioner "local-exec" {
    command = <<EOM
curl -s https://api.equinix.com/metal/v1/virtual-circuits/$VC_ID -X PUT -H 'Content-Type: application/json' -H "X-Auth-Token:$AUTH_TOKEN" --data '{"peer_asn":'$PEER_ASN',"subnet":"'$SUBNET'","metal_ip":"'$METAL_IP'","customer_ip":"'$CUSTOMER_IP'","md5":"'$MD5'"}'
EOM
    interpreter = ["bash", "-c"]
    environment = {
      VC_ID = equinix_metal_connection.vcf_vrf_connection-metal.ports[1].virtual_circuit_ids[0]
      AUTH_TOKEN = var.metal_auth_token
      PEER_ASN = var.metal_vrf_peer_asn
      SUBNET = var.metal_vrf_peer_subnet-sec
      METAL_IP = var.metal_vrf_metal_bgp_peer-sec
      CUSTOMER_IP = var.metal_vrf_cust_bgp_peer-sec
      MD5 = var.metal_vrf_shared_md5-sec
    }
  }
  depends_on = [equinix_fabric_connection.vcf_vrf_connection-sec,equinix_metal_vrf.vcf_vrf]
}