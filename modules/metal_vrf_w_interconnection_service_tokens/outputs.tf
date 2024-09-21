output "vrf_id" {
  description = "ID of the Metal VRF"
  value       = equinix_metal_vrf.vcf_vrf.id
}
output "vrf_interconnection_service_tokens" {
  description = "Service Tokens from VRF Interconnect Request"
  value       = equinix_metal_connection.vcf_vrf_connection_metal.service_tokens
}
