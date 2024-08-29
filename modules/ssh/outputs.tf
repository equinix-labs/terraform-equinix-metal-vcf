output "ssh_private_key" {
  description = "private key file for bastion host"
  value       = local.ssh_key_file
}

output "ssh_private_key_contents" {
  description = "private key contents for bastion host"
  value       = chomp(tls_private_key.ssh_key_pair.private_key_pem)
  sensitive   = true
}

output "equinix_metal_ssh_key_id" {
  description = "public key for bastion host"
  value       = equinix_metal_project_ssh_key.ssh_pub_key.id
}
