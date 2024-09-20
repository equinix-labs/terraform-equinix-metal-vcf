output "vrf_id" {
  description = "ID of the Metal VRF"
  value       = equinix_metal_vrf.vcf_vrf.id
}
output "VRF_Interconnection_Service_Tokens" {
  description = "Service Tokens from VRF Interconnect Request"
  value = equinix_metal_connection.vcf_vrf_connection_metal.service_tokens
}