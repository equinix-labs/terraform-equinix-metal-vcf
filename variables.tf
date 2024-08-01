variable "metal_auth_token" {
    type = string
    description = "API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/"
}
variable "metal_project_id" {
    type = string
    description = "Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles"
}
variable "fabric_client_id" {
    type = string
    description = "Client ID for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview"
}
variable "fabric_client_secret" {
    type = string
    description = "Client Secret for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview"
}
variable "metro" {
    type = string
    description = "Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference"
}
variable "primary_ne_device_uuid" {
    type = string
    description = "UUID of Primary Network Edge Device for interconenction to Metal VRF"
}
variable "secondary_ne_device_uuid" {
    type = string
    description = "UUID of Secondary Network Edge Device for interconenction to Metal VRF"
}
variable "primary_ne_device_port" {
    type = number
    description = "Port Number on Primary Network Edge Device for interconnection to Metal VRF"
}
variable "secondary_ne_device_port" {
    type = number
    description = "Port Number on Secondary Network Edge Device for interconnection to Metal VRF"
}
variable "vrf_interconnection_speed" {
    type = number
    description = "Metal VRF interconnection speed"
}
variable "vrf_interconnection_notification_email" {
    type = string
    description = "Email address for interconnection notifications"
}
variable "metal_vrf_asn" {
    type = string
    description = "ASN to be used for Metal VRF https://deploy.equinix.com/developers/docs/metal/networking/vrf/"
}
variable "vrf_peer_subnet" {
  type = string
  description = "Subnet used for both Metal VRF interconnections (/29 or larger)"
}
variable "vrf_peer_asn" {
  type = string
  description = "ASN that will establish BGP Peering with the Metal VRF across the interconnections"
}
variable "vrf_peer_subnet-pri" {
  type = string
  description = "Subnet used for point to point Metal VRF BGP Neighbor connection across the Primary interconnection"
}
variable "vrf_bgp_customer_peer_ip-pri" {
  type = string
  description = "IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with"
}
variable "vrf_bgp_metal_peer_ip-pri" {
  type = string
  description = "IP of Metal VRF on Primary Interconnection for peering with BGP Neighbor"
}
variable "vrf_bgp_md5-pri" {
  type = string
  description = "MD5 Shared Password for BGP session authentication"
}
variable "vrf_peer_subnet-sec" {
  type = string
  description = "Subnet used for point to point Metal VRF BGP Neighbor connection across the Secondary interconnection"
}
variable "vrf_bgp_customer_peer_ip-sec" {
  type = string
  description = "IP of BGP Neighbor on Secondary Interconnection that Metal VRF should expect to peer with"
}
variable "vrf_bgp_metal_peer_ip-sec" {
  type = string
  description = "IP of Metal VRF on Secondary Interconnection for peering with BGP Neighbor"
}
variable "vrf_bgp_md5-sec" {
  type = string
  description = "MD5 Shared Password for BGP session authentication"
}
variable "vcf_vrf_networks" {
    type = map(object({
        vlan_id = string                        # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > C7:C10) 802.1q VLAN number
        vlan_name = string                      # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > D7:D10) Preferred Description of Metal VLAN
        subnet = string                         # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > E7:E10) CIDR Subnet to be used within this Metal VLAN 
        enable_dyn_nei = optional(bool, false)  # Whether or not to configure BGP Dynamic Neighbor functionality on the gateway, only use for NSX-t Edge uplink VLANs if NSX-t will peer with Metal VRF
        dyn_nei_range = optional(string, "")    # CIDR Range of IPs that the Metal VRF should expect BGP Peering from
        dyn_nei_asn = optional(string, "")      # ASN that the Metal VRF should expect BGP Peering from
    }))
    description = "Map of Objects representing configuration specifics for various network segments required for VCF Management and Underlay Networking"
}
variable "vm-mgmt_vlan" {
    type = string
    description = "VLAN ID of VM Management VLAN for VCF Infrastrucutre VMs (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > C7)"
}
variable "esxi_devices" {
    type = map(object({
        name = string       # Short form hostname of system (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I6:L6)
        mgmt_ip = string    # Management Network IP address for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I7:L7)
    }))
    description = "Map containing individual ESXi device details for each Metal Instance"
}
variable "esxi_subnet" {
    type = string
    description = "Management Network Subnet Mask for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > E8)"
}
variable "esxi_gateway" {
    type = string
    description = "Management Network Gateway for ESXi default TCP/IP Stack (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > F8)"
}
variable "esxi_dns" {
    type = string
    description = "DNS Server to be configured in ESXi (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > F6:G6)"
}
variable "esxi_domain" {
    type = string
    description = "Domain Name to be configured in ESXi FQDN along with name in Map above (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > J6:K6)"
}
variable "esxi_mgmtvlan" {
    type = string
    description = "VLAN ID of Management VLAN for ESXi Management Network portgroup/VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > C8)"
}
variable "esxi_ntp" {
    type = string
    description = "NTP Server to be configured in ESXi (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > F8:G8)"
}
variable "esxi_pw" {
    type = string
    description = "mkpasswd Pre-hashed root password to be set for ESXi instances (Hash the password from vcf-ems-deployment-parameter.xlsx > Credentials Sheet > C8 using 'mkpasswd --method=SHA-512' from Linux whois package)"
}
variable "esxi_size" {
    type = string
    description = "Slug for target hardware plan type. The only officially supported server plan for ESXi/VCF is the 'n3.xlarge.opt-m4s2' https://deploy.equinix.com/product/servers/n3-xlarge-opt-m4s2/"
}
variable "esxi_version" {
    type = string
    description = "Slug for ESXi OS version to be deployed on Metal Instances https://github.com/equinixmetal-images/changelog/blob/main/vmware-esxi/x86_64/8.md"
}
variable "billing_cycle" {
    type = string
    description = "The billing cycle of the device ('hourly', 'daily', 'monthly', 'yearly') when in doubt, use 'hourly'"
}