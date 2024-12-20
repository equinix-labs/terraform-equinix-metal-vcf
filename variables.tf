variable "metal_auth_token" {
  type        = string
  sensitive   = true
  description = "API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/"
}
variable "metal_project_id" {
  type        = string
  description = "Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles"
}
variable "metro" {
  type        = string
  description = "Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference"
}
variable "metal_vrf_asn" {
  type        = string
  description = "ASN to be used for Metal VRF https://deploy.equinix.com/developers/docs/metal/networking/vrf/"
}
variable "vrf_peer_subnet" {
  type        = string
  description = "Subnet used for both Metal VRF interconnections (/29 or larger)"
}
variable "vrf_peer_asn" {
  type        = string
  description = "ASN that will establish BGP Peering with the Metal VRF across the interconnections"
}
variable "vrf_peer_subnet_pri" {
  type        = string
  description = "Subnet used for point to point Metal VRF BGP Neighbor connection across the Primary interconnection"
}
variable "vrf_bgp_customer_peer_ip_pri" {
  type        = string
  description = "IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with"
}
variable "vrf_bgp_metal_peer_ip_pri" {
  type        = string
  description = "IP of Metal VRF on Primary Interconnection for peering with BGP Neighbor"
}
variable "vrf_bgp_md5_pri" {
  type        = string
  description = "MD5 Shared Password for BGP session authentication"
}
variable "vrf_peer_subnet_sec" {
  type        = string
  description = "Subnet used for point to point Metal VRF BGP Neighbor connection across the Secondary interconnection"
}
variable "vrf_bgp_customer_peer_ip_sec" {
  type        = string
  description = "IP of BGP Neighbor on Secondary Interconnection that Metal VRF should expect to peer with"
}
variable "vrf_bgp_metal_peer_ip_sec" {
  type        = string
  description = "IP of Metal VRF on Secondary Interconnection for peering with BGP Neighbor"
}
variable "vrf_bgp_md5_sec" {
  type        = string
  description = "MD5 Shared Password for BGP session authentication"
}
variable "vcf_vrf_networks" {
  type = map(object({
    vlan_id        = string                # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > C7:C10) 802.1q VLAN number
    vlan_name      = string                # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > D7:D10) Preferred Description of Metal VLAN
    subnet         = optional(string, "")  # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > E7:E10) CIDR Subnet to be used within this Metal VLAN
    enable_dyn_nei = optional(bool, false) # Whether or not to configure BGP Dynamic Neighbor functionality on the gateway, only use for NSX-t Edge uplink VLANs if NSX-t will peer with Metal VRF
    dyn_nei_range  = optional(string, "")  # CIDR Range of IPs that the Metal VRF should expect BGP Peering from
    dyn_nei_asn    = optional(string, "")  # ASN that the Metal VRF should expect BGP Peering from
  }))
  description = "Map of Objects representing configuration specifics for various network segments required for VCF Management and Underlay Networking"
}
variable "esxi_devices" {
  type = map(object({
    name           = string               # Short form hostname of system (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I6:L6)
    mgmt_ip        = string               # Management Network IP address for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I7:L7)
    reservation_id = optional(string, "") # Hardware reservation IDs to use for the VCF nodes. Each item can be a reservation UUID or `next-available`.
  }))
  description = "Map containing individual ESXi device details for each Metal Instance"
}
variable "esxi_management_subnet" {
  type        = string
  description = "Management Network Subnet Mask for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > E8)"
}
variable "esxi_management_gateway" {
  type        = string
  description = "Management Network Gateway for ESXi default TCP/IP Stack (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > F8)"
}
variable "zone_name" {
  type        = string
  description = "DNS Zone name to use for deployment (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > J6:K6)"
}
variable "esxi_password" {
  type        = string
  sensitive   = true
  description = "mkpasswd Pre-hashed root password to be set for ESXi instances (Hash the password from vcf-ems-deployment-parameter.xlsx > Credentials Sheet > C8 using 'mkpasswd --method=SHA-512' from Linux whois package)"
  validation {
    condition     = length(var.esxi_password) >= 98 && substr(var.esxi_password, 0, 3) == "$6$"
    error_message = "The esxi_password value must be a valid SHA 512 password hash, starting with \"$6$\". Use 'mkpasswd --method=SHA-512' from the whois package to generate a valid hash."
  }
}
variable "esxi_plan" {
  type        = string
  description = "Slug for target hardware plan type. The only officially supported server plan for ESXi/VCF is the 'n3.xlarge.opt-m4s2' https://deploy.equinix.com/product/servers/n3-xlarge-opt-m4s2/"
}
variable "esxi_version_slug" {
  type        = string
  description = "Slug for ESXi OS version to be deployed on Metal Instances https://github.com/equinixmetal-images/changelog/blob/main/vmware-esxi/x86_64/8.md"
}
variable "windows_management_plan" {
  type        = string
  default     = "m3.small.x86"
  description = "Which plan to use for the windows management host."
}
variable "windows_management_name" {
  type        = string
  description = "Hostname for the Windows management host"
  default     = "management"
}
variable "windows_management_ip" {
  type        = string
  description = "IP address for the Windows management host"
}
variable "bastion_plan" {
  type        = string
  default     = "m3.small.x86"
  description = "Which plan to use for the ubuntu based bastion host."
}
variable "bastion_name" {
  type        = string
  description = "Hostname for the Bastion host"
  default     = "bastion"
}
variable "bastion_ip" {
  type        = string
  description = "IP address for the Bastion host"
}
variable "esxi_network_space" {
  type        = string
  description = "Overall Network space for the VCF project"
}
variable "cloudbuilder_name" {
  type        = string
  description = "Hostname for the Cloudbuilder appliance"
  default     = "cloudbuilder"
}
variable "cloudbuilder_ip" {
  type        = string
  description = "IP address for the Cloudbuilder appliance"
}
variable "nsx_devices" {
  type = map(object({
    name = string # Short form hostname of system (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I6:L6)
    ip   = string # Management Network IP address for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I7:L7)
  }))
  description = "Map containing NSX Cluster host and IP details"
}
variable "sddc_manager_name" {
  type        = string
  description = "Hostname for the SDDC Manager"
}
variable "sddc_manager_ip" {
  type        = string
  description = "IP address for the SDDC Manager"
}
variable "vcenter_name" {
  type        = string
  description = "Hostname for the vCenter Server"
}
variable "vcenter_ip" {
  type        = string
  description = "IP address for the vCenter Server"
}
