# main.tf
terraform {
  required_version = ">= 1.0"

  required_providers {
    equinix = {
      source = "equinix/equinix"
    }
  }
}

variable "metal_auth_token" {
  description = "API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/"
  sensitive   = true
  type        = string
}

variable "metal_project_id" {
  description = "Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles"
  type        = string
}

variable "equinix_client_id" {
  description = "Client ID for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview"
  type        = string
  default     = ""
}

variable "equinix_client_secret" {
  description = "Client Secret for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview"
  sensitive   = true
  type        = string
  default     = ""
}

variable "equinix_metal_metro" {
  description = "Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference"
  type        = string
}

variable "esxi_password" {
  description = "Pre-hashed root password to be set for ESXi instances"
  sensitive   = true
  type        = string
}

variable "email" {
  description = "Email address for interconnection notifications (must be valid email address format)"
  type        = string
}

module "example" {
  source = "git::https://github.com/equinix-labs/terraform-equinix-metal-vcf?ref=update-readme"
  # Published modules can be sourced as:
  # source = "equinix-labs/terraform-equinix-metal-vcf/equinix"
  # See https://www.terraform.io/docs/registry/modules/publish.html for details.

  # version = "0.1.0"

  ## Metal Auth
  metal_auth_token = var.metal_auth_token # API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/
  metal_project_id = var.metal_project_id # Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles

  ## Fabric/NE Auth
  equinix_client_id     = var.equinix_client_id     # Client ID for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview
  equinix_client_secret = var.equinix_client_secret # Client Secret for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview

  # Metro for this deployment
  metro = var.equinix_metal_metro # Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference

  # Network Edge Device UUIDs and notification email for Metal VRF Interconnections
  primary_ne_device_uuid                 = ""        # UUID of Primary Network Edge Device for interconnection to Metal VRF
  secondary_ne_device_uuid               = ""        # UUID of Secondary Network Edge Device for interconnection to Metal VRF
  primary_ne_device_port                 = 3         # Port Number on Primary Network Edge Device for interconnection to Metal VRF
  secondary_ne_device_port               = 3         # Port Number on Secondary Network Edge Device for interconnection to Metal VRF
  vrf_interconnection_speed              = 200       # Metal VRF interconnection speed
  vrf_interconnection_notification_email = var.email # Email address for interconnection notifications

  # Metal VRF ASN
  metal_vrf_asn = "65100"

  ## Metal VRF Peering details for Interconnection Uplinks
  vrf_peer_subnet              = "172.31.255.0/29" # Subnet used for both Metal VRF interconnections (/29 or larger)
  vrf_peer_asn                 = "65534"           # ASN that will establish BGP Peering with the Metal VRF across the interconnections
  vrf_peer_subnet_pri          = "172.31.255.0/30" # Subnet used for point to point connection across the Primary interconnection
  vrf_bgp_customer_peer_ip_pri = "172.31.255.2"    # IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with
  vrf_bgp_metal_peer_ip_pri    = "172.31.255.1"    # IP of Metal VRF on Primary Interconnect for peering with BGP Neighbor
  vrf_bgp_md5_pri              = ""                # MD5 Shared Password for BGP Session authentication
  vrf_peer_subnet_sec          = "172.31.255.4/30" # Subnet used for point to point connection across the Primary interconnection
  vrf_bgp_customer_peer_ip_sec = "172.31.255.6"    # IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with
  vrf_bgp_metal_peer_ip_sec    = "172.31.255.5"    # IP of Metal VRF on Primary Interconnect for peering with BGP Neighbor
  vrf_bgp_md5_sec              = ""                # MD5 Shared Password for BGP Session authentication

  ## VLAN and Metal Gateway provisioning with VRF Subnets and
  ## Optional Dynamic Neighbor Ranges for BGP Peering with the
  ## Metal VRF from inside the Metal Project
  ## 2712" = {
  ##      vlan_id         = "2712"                # 802.1q VLAN number
  ##      vlan_name       = "NSXt_Edge_Uplink2"   # Preferred Description of Metal VLAN
  ##      subnet          = "172.27.12.0/24"      # Subnet to be used within this Metal VLAN
  ##      enable_dyn_nei  = true                  # Whether or not to configure BGP Dynamic Neighbor functionality on the gateway
  ##      dyn_nei_range   = "172.27.12.2/31"      # CIDR Range of IPs that the Metal VRF should expect BGP Peering from
  ##      dyn_nei_asn     = "65101"               # ASN that the Metal VRF should expect BGP Peering from
  vcf_vrf_networks = {
    "bastion" = {
      vlan_id        = "1609"
      vlan_name      = "Bastion_Network"
      subnet         = "172.16.9.0/24"
      enable_dyn_nei = true
      dyn_nei_range  = "172.16.9.2/31"
      dyn_nei_asn    = "65101"
    },
    "vm-mgmt" = {
      vlan_id   = "1610"
      vlan_name = "VM-Management_Network"
      subnet    = "172.16.10.0/24"
    },
    "mgmt" = {
      vlan_id   = "1611"
      vlan_name = "Management_Network"
      subnet    = "172.16.11.0/24"
    },
    "vMotion" = {
      vlan_id   = "1612"
      vlan_name = "vMotion_Network"
      subnet    = "172.16.12.0/24"
    },
    "vSAN" = {
      vlan_id   = "1613"
      vlan_name = "vSAN_Network"
      subnet    = "172.16.13.0/24"
    },
    "NSXt" = {
      vlan_id   = "1614"
      vlan_name = "NSXt_Host_Overlay"
      subnet    = "172.16.14.0/24"
    },
    "NSXt_Edge" = {
      vlan_id   = "2713"
      vlan_name = "NSXt_Edge_overlay"
      subnet    = "172.27.13.0/24"
    },
    "NSXt_Uplink1" = {
      vlan_id        = "2711"
      vlan_name      = "NSXt_Edge_Uplink1"
      subnet         = "172.27.11.0/24"
      enable_dyn_nei = true
      dyn_nei_range  = "172.27.11.2/31"
      dyn_nei_asn    = "65101"
    },
    "NSXt_Uplink2" = {
      vlan_id        = "2712"
      vlan_name      = "NSXt_Edge_Uplink2"
      subnet         = "172.27.12.0/24"
      enable_dyn_nei = true
      dyn_nei_range  = "172.27.12.2/31"
      dyn_nei_asn    = "65101"
    }
  }

  ## ESXi individual device details
  ## "sfo01-m01-esx01" = {
  ##     name         = "sfo01-m01-esx01"   # Short form hostname of system
  ##     mgmt_ip      = "172.16.11.101"     # Management Network IP address for VMK0
  ##    reservation_id = "next-available" # Hardware reservation IDs to use for the VCF nodes. Each item can be a reservation UUID or `next-available`.
  esxi_devices = {
    "sfo01-m01-esx01" = {
      name    = "sfo01-m01-esx01"
      mgmt_ip = "172.16.11.101"
    },
    "sfo01-m01-esx02" = {
      name    = "sfo01-m01-esx02"
      mgmt_ip = "172.16.11.102"
    },
    "sfo01-m01-esx03" = {
      name    = "sfo01-m01-esx03"
      mgmt_ip = "172.16.11.103"
    },
    "sfo01-m01-esx04" = {
      name    = "sfo01-m01-esx04"
      mgmt_ip = "172.16.11.104"
    }
  }

  ## ESXi device common details
  esxi_network_space      = "172.16.0.0/16"
  esxi_management_subnet  = "255.255.255.0"      # Management Network Subnet Mask for VMK0
  esxi_management_gateway = "172.16.11.1"        # Management Network Gateway for default TCP/IP Stack
  esxi_dns_server         = "172.16.1.1"         # DNS Server to be configured in ESXi
  esxi_domain             = "sfo.rainpole.io"    # Domain Name to be configured in ESXi FQDN along with name above
  esxi_mgmt_vlan          = "1611"               # VLAN ID of Management VLAN for ESXi Management Network portgroup/VMK0
  esxi_ntp_server         = "172.16.1.1"         # NTP Server to be configured in ESXi
  esxi_password           = var.esxi_password    # Pre-hashed root password to be set for ESXi instances https://github.com/equinix-labs/terraform-equinix-metal-vcf?tab=readme-ov-file#custom-root-password
  esxi_size               = "n3.xlarge.x86-m4s2" # Slug for target hardware plan type. The only officially supported server plan for ESXi/VCF is the 'n3.xlarge.opt-m4s2' https://deploy.equinix.com/product/servers/n3-xlarge-opt-m4s2/
  esxi_version_slug       = "vmware_vcf_5_1"     # Slug for ESXi OS version to be deployed on Metal Instances https://github.com/equinixmetal-images/changelog/blob/main/vmware-esxi/x86_64/8.md

  ## Management Host Details
  management_plan = "m3.small.x86"
  bastion_plan    = "m3.small.x86"
}
