
output "ssh_private_key" {
  description = "SSH Private key to use to connect to bastion and management hosts over SSH."
  value       = module.ssh.ssh_private_key
  sensitive   = false
}
output "bastion_public_ip" {
  description = "The public IP address of the bastion host."
  value       = equinix_metal_device.bastion.access_public_ipv4
}
output "management_public_ip" {
  description = "The public IP address of the windows management host."
  value       = equinix_metal_device.management.access_public_ipv4
}
output "management_password" {
  description = "Randomly generated password used for the Admin accounts on the management host."
  sensitive   = true
  value       = random_password.management.result
}

output "next_steps" {
  description = "Instructions for accessing the management host."
  value       = "Run `terraform output -raw management_password` to see the management host's admin password and then RDP to the Management host as SYSTEM\\Admin with that password."
}

output "esx01_address" {
  description = "The public IP address of the first ESXi host."
  value       = "https://${var.esxi_devices["esx01"].name}.${var.esxi_domain}"
}
