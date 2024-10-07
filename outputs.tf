

output "bastion_public_ip" {
  description = "The public IP address of the bastion host. Used for troubleshooting."
  value       = equinix_metal_device.bastion.access_public_ipv4
}
output "esx01_web_address" {
  description = "The web address of the first ESXi host to use in a browser on the management host."
  value       = "https://${var.esxi_devices["esx01"].name}.${var.zone_name}"
}
output "windows_management_rdp_address" {
  description = "The public IP address of the windows management host."
  value       = equinix_metal_device.management.access_public_ipv4
}
output "windows_management_password" {
  description = "Randomly generated password used for the Admin accounts on the management host."
  sensitive   = true
  value       = random_password.management.result
}
output "ssh_private_key" {
  description = "Path to the SSH Private key to use to connect to bastion and management hosts over SSH."
  value       = module.ssh.ssh_private_key
  sensitive   = false
}
output "cloudbuilder_hostname" {
  description = "Cloudbuilder Hostname to use during OVA deployment."
  value       = var.cloudbuilder_name
}
output "cloudbuilder_ip" {
  description = "Cloudbuilder IP to use during OVA deployment."
  value       = var.cloudbuilder_ip
}
output "cloudbuilder_subnet_mask" {
  description = "Cloudbuilder Subnet Mask to use during OVA deployment."
  value       = cidrnetmask(var.vcf_vrf_networks["bastion"].subnet)
}
output "cloudbuilder_default_gateway" {
  description = "Cloudbuilder Default Gateway to use during OVA deployment."
  value       = cidrhost(var.vcf_vrf_networks["vm-mgmt"].subnet, 1)
}
output "dns_server" {
  description = "DNS Server to use during OVA deployment."
  value       = var.bastion_ip
}
output "dns_domain_name" {
  description = "DNS Domain Name to use during OVA deployment."
  value       = var.zone_name
}
output "dns_domain_search_paths" {
  description = "DNS Domain Search Paths to use during OVA deployment."
  value       = var.zone_name
}
output "ntp_server" {
  description = "NTP Server to use during OVA deployment."
  value       = var.bastion_ip
}
output "cloudbuilder_web_address" {
  description = "Cloudbuilder Web Address"
  value       = "https://${var.cloudbuilder_name}.${var.zone_name}"
}
