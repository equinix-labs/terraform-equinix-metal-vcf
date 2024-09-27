# Equinix Metal VRF with Interconnection to Network Edge

This module creates the VRF and Interconnection to Network Edge on Equinix Metal.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | >= 1.35.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_equinix"></a> [equinix](#provider\_equinix) | >= 1.35.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [equinix_metal_connection.vcf_vrf_connection_metal](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_connection) | resource |
| [equinix_metal_vrf.vcf_vrf](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_vrf) | resource |
| [null_resource.vcf_vrf_bgp_dynamic_neighbor](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.vcf_vrf_bgp_pri](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.vcf_vrf_bgp_sec](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_equinix_client_id"></a> [equinix\_client\_id](#input\_equinix\_client\_id) | Client ID for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview | `string` | n/a | yes |
| <a name="input_equinix_client_secret"></a> [equinix\_client\_secret](#input\_equinix\_client\_secret) | Client Secret for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview | `string` | n/a | yes |
| <a name="input_metal_auth_token"></a> [metal\_auth\_token](#input\_metal\_auth\_token) | API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/ | `string` | n/a | yes |
| <a name="input_metal_metro"></a> [metal\_metro](#input\_metal\_metro) | Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference | `string` | n/a | yes |
| <a name="input_metal_project_id"></a> [metal\_project\_id](#input\_metal\_project\_id) | Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles | `string` | n/a | yes |
| <a name="input_metal_vrf_asn"></a> [metal\_vrf\_asn](#input\_metal\_vrf\_asn) | ASN to be used for Metal VRF https://deploy.equinix.com/developers/docs/metal/networking/vrf/ | `string` | n/a | yes |
| <a name="input_metal_vrf_cust_bgp_peer_pri"></a> [metal\_vrf\_cust\_bgp\_peer\_pri](#input\_metal\_vrf\_cust\_bgp\_peer\_pri) | IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with | `string` | n/a | yes |
| <a name="input_metal_vrf_cust_bgp_peer_sec"></a> [metal\_vrf\_cust\_bgp\_peer\_sec](#input\_metal\_vrf\_cust\_bgp\_peer\_sec) | IP of BGP Neighbor on Secondary Interconnection that Metal VRF should expect to peer with | `string` | n/a | yes |
| <a name="input_metal_vrf_ip_ranges"></a> [metal\_vrf\_ip\_ranges](#input\_metal\_vrf\_ip\_ranges) | All IP Address Ranges to be used by Metal VRF, including Metal VRF Gateway subnets and Interconnection point to point networks (eg /29 to cover two /30 interconnections) | `set(string)` | n/a | yes |
| <a name="input_metal_vrf_metal_bgp_peer_pri"></a> [metal\_vrf\_metal\_bgp\_peer\_pri](#input\_metal\_vrf\_metal\_bgp\_peer\_pri) | IP of Metal VRF on Primary Interconnection for peering with BGP Neighbor | `string` | n/a | yes |
| <a name="input_metal_vrf_metal_bgp_peer_sec"></a> [metal\_vrf\_metal\_bgp\_peer\_sec](#input\_metal\_vrf\_metal\_bgp\_peer\_sec) | IP of Metal VRF on Secondary Interconnection for peering with BGP Neighbor | `string` | n/a | yes |
| <a name="input_metal_vrf_peer_asn"></a> [metal\_vrf\_peer\_asn](#input\_metal\_vrf\_peer\_asn) | ASN that will establish BGP Peering with the Metal VRF across the interconnections | `string` | n/a | yes |
| <a name="input_metal_vrf_peer_subnet_pri"></a> [metal\_vrf\_peer\_subnet\_pri](#input\_metal\_vrf\_peer\_subnet\_pri) | Subnet used for point to point Metal VRF BGP Neighbor connection across the Primary interconnection | `string` | n/a | yes |
| <a name="input_metal_vrf_peer_subnet_sec"></a> [metal\_vrf\_peer\_subnet\_sec](#input\_metal\_vrf\_peer\_subnet\_sec) | Subnet used for point to point Metal VRF BGP Neighbor connection across the Secondary interconnection | `string` | n/a | yes |
| <a name="input_metal_vrf_shared_md5_pri"></a> [metal\_vrf\_shared\_md5\_pri](#input\_metal\_vrf\_shared\_md5\_pri) | MD5 Shared Password for BGP session authentication | `string` | n/a | yes |
| <a name="input_metal_vrf_shared_md5_sec"></a> [metal\_vrf\_shared\_md5\_sec](#input\_metal\_vrf\_shared\_md5\_sec) | MD5 Shared Password for BGP session authentication | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vrf_id"></a> [vrf\_id](#output\_vrf\_id) | ID of the Metal VRF |
| <a name="output_vrf_interconnection_service_tokens"></a> [vrf\_interconnection\_service\_tokens](#output\_vrf\_interconnection\_service\_tokens) | Service Tokens from VRF Interconnect Request |
<!-- END_TF_DOCS -->
