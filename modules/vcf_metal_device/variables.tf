variable "metal_auth_token" {
    type = string
    description = "API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/"
}
variable "metal_project_id" {
    type = string
    description = "Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles"
}
variable "metal_metro" {
    type = string
    description = "Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference"
}
variable "metal_billing_cycle" {
    type = string
    default = "hourly"
    description = "The billing cycle of the device ('hourly', 'daily', 'monthly', 'yearly') when in doubt, use 'hourly'"
}
variable "metal_device_plan" {
    type = string
    description = "Slug for target hardware plan type. The only officially supported server plan for ESXi/VCF is the 'n3.xlarge.opt-m4s2' https://deploy.equinix.com/product/servers/n3-xlarge-opt-m4s2/"
}
variable "esxi_hostname" {
    type = string
    description = "Short form hostname of system"
}
variable "esxi_version_slug" {
    type = string
    description = "Slug for ESXi OS version to be deployed on Metal Instances https://github.com/equinixmetal-images/changelog/blob/main/vmware-esxi/x86_64/8.md"
}
variable "esxi_password" {
    type = string
    description = "mkpasswd Pre-hashed root password to be set for ESXi instances (Hash the password from vcf-ems-deployment-parameter.xlsx > Credentials Sheet > C8 using 'mkpasswd --method=SHA-512' from Linux whois package)"
}
variable "esxi_management_ip" {
    type = string
    description = "Management Network IP address for VMK0"
}
variable "esxi_management_gateway" {
    type = string
    description = "Management Network Gateway for ESXi default TCP/IP Stack"
}
variable "esxi_management_subnet" {
    type = string
    description = "Management Network Subnet Mask for VMK0"
}
variable "esxi_dns_server" {
    type = string
    description = "DNS Server to be configured in ESXi"
}
variable "esxi_domain" {
    type = string
    description = "Domain Name to be configured in ESXi FQDN along with shortname above"
}
variable "vm-mgmt_vlan" {
    type = string
    description = "VLAN ID of VM Management VLAN for the default VM Network portgroup"
}
variable "esxi-mgmt_vlan" {
    type = string
    description = "VLAN ID of Management VLAN for ESXi Management Network portgroup/VMK0"
}
variable "esxi_ntp_server" {
    type = string
    description = "NTP Server to be configured in ESXi"
}
variable "esxi_assigned_vlans" {
    type = set(string)
    description = "A set of strings containing Metal VLAN UUIDs that are to be assigned/attached to the eth0/eth1 interfaces of the ESXi Metal instance"
}