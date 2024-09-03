# Equinix Metal VCF Metal Device

This module creates the VCF devices on Equinix Metal.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | >= 1.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_equinix"></a> [equinix](#provider\_equinix) | >= 1.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [equinix_metal_device.esx](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_device) | resource |
| [equinix_metal_port.eth0](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_port) | resource |
| [equinix_metal_port.eth1](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_port) | resource |
| [equinix_metal_port.eth2](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_port) | resource |
| [equinix_metal_port.eth3](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_port) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_esxi_assigned_vlans"></a> [esxi\_assigned\_vlans](#input\_esxi\_assigned\_vlans) | A set of strings containing Metal VLAN UUIDs that are to be assigned/attached to the eth0/eth1 interfaces of the ESXi Metal instance | `set(string)` | n/a | yes |
| <a name="input_esxi_dns_server"></a> [esxi\_dns\_server](#input\_esxi\_dns\_server) | DNS Server to be configured in ESXi | `string` | n/a | yes |
| <a name="input_esxi_domain"></a> [esxi\_domain](#input\_esxi\_domain) | Domain Name to be configured in ESXi FQDN along with shortname above | `string` | n/a | yes |
| <a name="input_esxi_hostname"></a> [esxi\_hostname](#input\_esxi\_hostname) | Short form hostname of system | `string` | n/a | yes |
| <a name="input_esxi_management_gateway"></a> [esxi\_management\_gateway](#input\_esxi\_management\_gateway) | Management Network Gateway for ESXi default TCP/IP Stack | `string` | n/a | yes |
| <a name="input_esxi_management_ip"></a> [esxi\_management\_ip](#input\_esxi\_management\_ip) | Management Network IP address for VMK0 | `string` | n/a | yes |
| <a name="input_esxi_management_subnet"></a> [esxi\_management\_subnet](#input\_esxi\_management\_subnet) | Management Network Subnet Mask for VMK0 | `string` | n/a | yes |
| <a name="input_esxi_mgmt_vlan"></a> [esxi\_mgmt\_vlan](#input\_esxi\_mgmt\_vlan) | VLAN ID of Management VLAN for ESXi Management Network portgroup/VMK0 | `string` | n/a | yes |
| <a name="input_esxi_ntp_server"></a> [esxi\_ntp\_server](#input\_esxi\_ntp\_server) | NTP Server to be configured in ESXi | `string` | n/a | yes |
| <a name="input_esxi_password"></a> [esxi\_password](#input\_esxi\_password) | mkpasswd Pre-hashed root password to be set for ESXi instances (Hash the password from vcf-ems-deployment-parameter.xlsx > Credentials Sheet > C8 using 'mkpasswd --method=SHA-512' from Linux whois package) | `string` | n/a | yes |
| <a name="input_esxi_reservation_id"></a> [esxi\_reservation\_id](#input\_esxi\_reservation\_id) | Hardware reservation IDs to use for the VCF nodes. Each item can be a reservation UUID or `next-available`. | `string` | n/a | yes |
| <a name="input_esxi_version_slug"></a> [esxi\_version\_slug](#input\_esxi\_version\_slug) | Slug for ESXi OS version to be deployed on Metal Instances https://github.com/equinixmetal-images/changelog/blob/main/vmware-esxi/x86_64/8.md | `string` | n/a | yes |
| <a name="input_metal_device_plan"></a> [metal\_device\_plan](#input\_metal\_device\_plan) | Slug for target hardware plan type. The only officially supported server plan for ESXi/VCF is the 'n3.xlarge.opt-m4s2' https://deploy.equinix.com/product/servers/n3-xlarge-opt-m4s2/ | `string` | n/a | yes |
| <a name="input_metal_metro"></a> [metal\_metro](#input\_metal\_metro) | Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference | `string` | n/a | yes |
| <a name="input_metal_project_id"></a> [metal\_project\_id](#input\_metal\_project\_id) | Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles | `string` | n/a | yes |
| <a name="input_vm_mgmt_vlan"></a> [vm\_mgmt\_vlan](#input\_vm\_mgmt\_vlan) | VLAN ID of VM Management VLAN for the default VM Network portgroup | `string` | n/a | yes |
| <a name="input_metal_billing_cycle"></a> [metal\_billing\_cycle](#input\_metal\_billing\_cycle) | The billing cycle of the device ('hourly', 'daily', 'monthly', 'yearly') when in doubt, use 'hourly' | `string` | `"hourly"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_device_id"></a> [device\_id](#output\_device\_id) | Metal Device ID |
| <a name="output_device_name"></a> [device\_name](#output\_device\_name) | Name of the Metal device |
| <a name="output_vmk0_ip"></a> [vmk0\_ip](#output\_vmk0\_ip) | IP Address set on vmk0 |
<!-- END_TF_DOCS -->
