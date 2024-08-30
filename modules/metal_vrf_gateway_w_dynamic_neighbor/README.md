# Metal VRF Gateway with Dynamic Neighbor

This module creates a Metal VRF Gateway with a dynamic BGP neighbor range.

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
| [equinix_metal_gateway.vrf_gateway](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_gateway) | resource |
| [equinix_metal_reserved_ip_block.vrf_gateway_ip_block](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_reserved_ip_block) | resource |
| [equinix_metal_vlan.vlan](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_vlan) | resource |
| [null_resource.vrf_bgp_dynamic_neighbor](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_metal_auth_token"></a> [metal\_auth\_token](#input\_metal\_auth\_token) | API Token for Equinix Metal API interaction <https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/> | `string` | n/a | yes |
| <a name="input_metal_project_id"></a> [metal\_project\_id](#input\_metal\_project\_id) | Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings <https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles> | `string` | n/a | yes |
| <a name="input_vrf_id"></a> [vrf\_id](#input\_vrf\_id) | UUID of VRF parent of the Metal VRF Gateway to be created | `string` | n/a | yes |
| <a name="input_vrfgw_dynamic_neighbor_asn"></a> [vrfgw\_dynamic\_neighbor\_asn](#input\_vrfgw\_dynamic\_neighbor\_asn) | ASN of the BGP Neighbors that will peer with the created Metal VRF Gateway | `string` | n/a | yes |
| <a name="input_vrfgw_dynamic_neighbor_range"></a> [vrfgw\_dynamic\_neighbor\_range](#input\_vrfgw\_dynamic\_neighbor\_range) | /31 IP Range of BGP Neighbors that will peer with the created Metal VRF Gateway | `string` | n/a | yes |
| <a name="input_vrfgw_enable_dynamic_neighbor"></a> [vrfgw\_enable\_dynamic\_neighbor](#input\_vrfgw\_enable\_dynamic\_neighbor) | Whether or not to configure BGP Dynamic Neighbor range on the created Metal VRF Gateway | `bool` | n/a | yes |
| <a name="input_vrfgw_metro"></a> [vrfgw\_metro](#input\_vrfgw\_metro) | Equinix Metal Metro where Metal resources are going to be deployed <https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference> | `string` | n/a | yes |
| <a name="input_vrfgw_subnet"></a> [vrfgw\_subnet](#input\_vrfgw\_subnet) | /29 or larger network subnet to be used for Metal VRF Gateway. Note: first usable IP in the specified range will be claimed by the Metal VRF Gateway itself | `string` | n/a | yes |
| <a name="input_vrfgw_vlan_name"></a> [vrfgw\_vlan\_name](#input\_vrfgw\_vlan\_name) | Description to associate with Metal VLAN being created for use use Metal VRF Gateway | `string` | n/a | yes |
| <a name="input_vrfgw_vxlan_id"></a> [vrfgw\_vxlan\_id](#input\_vrfgw\_vxlan\_id) | Metal VLAN ID (802.1q ie. 2-3999) to be created for use with Metal VRF Gateway | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vlan_uuid"></a> [vlan\_uuid](#output\_vlan\_uuid) | ID of the Metal VRF |
<!-- END_TF_DOCS -->
