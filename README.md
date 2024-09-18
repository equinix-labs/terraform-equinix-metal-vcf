# terraform-vcf-metal-deployment

This Terraform module deploys a VMware Cloud Foundation (VCF) environment on Equinix Metal.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | >= 1.35 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_equinix"></a> [equinix](#provider\_equinix) | >= 1.35 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_metal_vrf"></a> [metal\_vrf](#module\_metal\_vrf) | ./modules/metal_vrf_w_interconnection_to_network_edge | n/a |
| <a name="module_metal_vrf_gateways_w_dynamic_neighbor"></a> [metal\_vrf\_gateways\_w\_dynamic\_neighbor](#module\_metal\_vrf\_gateways\_w\_dynamic\_neighbor) | ./modules/metal_vrf_gateway_w_dynamic_neighbor | n/a |
| <a name="module_ssh"></a> [ssh](#module\_ssh) | ./modules/ssh/ | n/a |
| <a name="module_vcf_metal_devices"></a> [vcf\_metal\_devices](#module\_vcf\_metal\_devices) | ./modules/vcf_metal_device | n/a |

## Resources

| Name | Type |
|------|------|
| [equinix_metal_bgp_session.bastion_bgp](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_bgp_session) | resource |
| [equinix_metal_bgp_session.management](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_bgp_session) | resource |
| [equinix_metal_device.bastion](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_device) | resource |
| [equinix_metal_device.management](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_device) | resource |
| [equinix_metal_port.bastion_bond0](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_port) | resource |
| [equinix_metal_port.management_bond0](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_port) | resource |
| [random_password.management](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_equinix_client_id"></a> [equinix\_client\_id](#input\_equinix\_client\_id) | Client ID for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview | `string` | n/a | yes |
| <a name="input_equinix_client_secret"></a> [equinix\_client\_secret](#input\_equinix\_client\_secret) | Client Secret for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview | `string` | n/a | yes |
| <a name="input_esxi_devices"></a> [esxi\_devices](#input\_esxi\_devices) | Map containing individual ESXi device details for each Metal Instance | <pre>map(object({<br>    name           = string # Short form hostname of system (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I6:L6)<br>    mgmt_ip        = string # Management Network IP address for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I7:L7)<br>    reservation_id = string # Hardware reservation IDs to use for the VCF nodes. Each item can be a reservation UUID or `next-available`.<br>  }))</pre> | n/a | yes |
| <a name="input_esxi_dns_server"></a> [esxi\_dns\_server](#input\_esxi\_dns\_server) | DNS Server to be configured in ESXi (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > F6:G6) | `string` | n/a | yes |
| <a name="input_esxi_domain"></a> [esxi\_domain](#input\_esxi\_domain) | Domain Name to be configured in ESXi FQDN along with name in Map above (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > J6:K6) | `string` | n/a | yes |
| <a name="input_esxi_management_gateway"></a> [esxi\_management\_gateway](#input\_esxi\_management\_gateway) | Management Network Gateway for ESXi default TCP/IP Stack (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > F8) | `string` | n/a | yes |
| <a name="input_esxi_management_subnet"></a> [esxi\_management\_subnet](#input\_esxi\_management\_subnet) | Management Network Subnet Mask for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > E8) | `string` | n/a | yes |
| <a name="input_esxi_mgmt_vlan"></a> [esxi\_mgmt\_vlan](#input\_esxi\_mgmt\_vlan) | VLAN ID of Management VLAN for ESXi Management Network portgroup/VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > C8) | `string` | n/a | yes |
| <a name="input_esxi_network_space"></a> [esxi\_network\_space](#input\_esxi\_network\_space) | Overall Network space for the VCF project | `string` | n/a | yes |
| <a name="input_esxi_ntp_server"></a> [esxi\_ntp\_server](#input\_esxi\_ntp\_server) | NTP Server to be configured in ESXi (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > F8:G8) | `string` | n/a | yes |
| <a name="input_esxi_password"></a> [esxi\_password](#input\_esxi\_password) | mkpasswd Pre-hashed root password to be set for ESXi instances (Hash the password from vcf-ems-deployment-parameter.xlsx > Credentials Sheet > C8 using 'mkpasswd --method=SHA-512' from Linux whois package) | `string` | n/a | yes |
| <a name="input_esxi_plan"></a> [esxi\_size](#input\_esxi\_size) | Slug for target hardware plan type. The only officially supported server plan for ESXi/VCF is the 'n3.xlarge.opt-m4s2' https://deploy.equinix.com/product/servers/n3-xlarge-opt-m4s2/ | `string` | n/a | yes |
| <a name="input_esxi_version_slug"></a> [esxi\_version\_slug](#input\_esxi\_version\_slug) | Slug for ESXi OS version to be deployed on Metal Instances https://github.com/equinixmetal-images/changelog/blob/main/vmware-esxi/x86_64/8.md | `string` | n/a | yes |
| <a name="input_metal_auth_token"></a> [metal\_auth\_token](#input\_metal\_auth\_token) | API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/ | `string` | n/a | yes |
| <a name="input_metal_project_id"></a> [metal\_project\_id](#input\_metal\_project\_id) | Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles | `string` | n/a | yes |
| <a name="input_metal_vrf_asn"></a> [metal\_vrf\_asn](#input\_metal\_vrf\_asn) | ASN to be used for Metal VRF https://deploy.equinix.com/developers/docs/metal/networking/vrf/ | `string` | n/a | yes |
| <a name="input_metro"></a> [metro](#input\_metro) | Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference | `string` | n/a | yes |
| <a name="input_primary_ne_device_port"></a> [primary\_ne\_device\_port](#input\_primary\_ne\_device\_port) | Port Number on Primary Network Edge Device for interconnection to Metal VRF | `number` | n/a | yes |
| <a name="input_primary_ne_device_uuid"></a> [primary\_ne\_device\_uuid](#input\_primary\_ne\_device\_uuid) | UUID of Primary Network Edge Device for interconenction to Metal VRF | `string` | n/a | yes |
| <a name="input_secondary_ne_device_port"></a> [secondary\_ne\_device\_port](#input\_secondary\_ne\_device\_port) | Port Number on Secondary Network Edge Device for interconnection to Metal VRF | `number` | n/a | yes |
| <a name="input_secondary_ne_device_uuid"></a> [secondary\_ne\_device\_uuid](#input\_secondary\_ne\_device\_uuid) | UUID of Secondary Network Edge Device for interconenction to Metal VRF | `string` | n/a | yes |
| <a name="input_vcf_vrf_networks"></a> [vcf\_vrf\_networks](#input\_vcf\_vrf\_networks) | Map of Objects representing configuration specifics for various network segments required for VCF Management and Underlay Networking | <pre>map(object({<br>    vlan_id        = string                # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > C7:C10) 802.1q VLAN number<br>    vlan_name      = string                # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > D7:D10) Preferred Description of Metal VLAN<br>    subnet         = string                # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > E7:E10) CIDR Subnet to be used within this Metal VLAN<br>    enable_dyn_nei = optional(bool, false) # Whether or not to configure BGP Dynamic Neighbor functionality on the gateway, only use for NSX-t Edge uplink VLANs if NSX-t will peer with Metal VRF<br>    dyn_nei_range  = optional(string, "")  # CIDR Range of IPs that the Metal VRF should expect BGP Peering from<br>    dyn_nei_asn    = optional(string, "")  # ASN that the Metal VRF should expect BGP Peering from<br>  }))</pre> | n/a | yes |
| <a name="input_vrf_bgp_customer_peer_ip_pri"></a> [vrf\_bgp\_customer\_peer\_ip\_pri](#input\_vrf\_bgp\_customer\_peer\_ip\_pri) | IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with | `string` | n/a | yes |
| <a name="input_vrf_bgp_customer_peer_ip_sec"></a> [vrf\_bgp\_customer\_peer\_ip\_sec](#input\_vrf\_bgp\_customer\_peer\_ip\_sec) | IP of BGP Neighbor on Secondary Interconnection that Metal VRF should expect to peer with | `string` | n/a | yes |
| <a name="input_vrf_bgp_md5_pri"></a> [vrf\_bgp\_md5\_pri](#input\_vrf\_bgp\_md5\_pri) | MD5 Shared Password for BGP session authentication | `string` | n/a | yes |
| <a name="input_vrf_bgp_md5_sec"></a> [vrf\_bgp\_md5\_sec](#input\_vrf\_bgp\_md5\_sec) | MD5 Shared Password for BGP session authentication | `string` | n/a | yes |
| <a name="input_vrf_bgp_metal_peer_ip_pri"></a> [vrf\_bgp\_metal\_peer\_ip\_pri](#input\_vrf\_bgp\_metal\_peer\_ip\_pri) | IP of Metal VRF on Primary Interconnection for peering with BGP Neighbor | `string` | n/a | yes |
| <a name="input_vrf_bgp_metal_peer_ip_sec"></a> [vrf\_bgp\_metal\_peer\_ip\_sec](#input\_vrf\_bgp\_metal\_peer\_ip\_sec) | IP of Metal VRF on Secondary Interconnection for peering with BGP Neighbor | `string` | n/a | yes |
| <a name="input_vrf_interconnection_notification_email"></a> [vrf\_interconnection\_notification\_email](#input\_vrf\_interconnection\_notification\_email) | Email address for interconnection notifications (must be valid email address format) | `string` | n/a | yes |
| <a name="input_vrf_interconnection_speed"></a> [vrf\_interconnection\_speed](#input\_vrf\_interconnection\_speed) | Metal VRF interconnection speed | `number` | n/a | yes |
| <a name="input_vrf_peer_asn"></a> [vrf\_peer\_asn](#input\_vrf\_peer\_asn) | ASN that will establish BGP Peering with the Metal VRF across the interconnections | `string` | n/a | yes |
| <a name="input_vrf_peer_subnet"></a> [vrf\_peer\_subnet](#input\_vrf\_peer\_subnet) | Subnet used for both Metal VRF interconnections (/29 or larger) | `string` | n/a | yes |
| <a name="input_vrf_peer_subnet_pri"></a> [vrf\_peer\_subnet\_pri](#input\_vrf\_peer\_subnet\_pri) | Subnet used for point to point Metal VRF BGP Neighbor connection across the Primary interconnection | `string` | n/a | yes |
| <a name="input_vrf_peer_subnet_sec"></a> [vrf\_peer\_subnet\_sec](#input\_vrf\_peer\_subnet\_sec) | Subnet used for point to point Metal VRF BGP Neighbor connection across the Secondary interconnection | `string` | n/a | yes |
| <a name="input_bastion_plan"></a> [bastion\_plan](#input\_bastion\_plan) | Which plan to use for the ubuntu based bastion host. | `string` | `"m3.small.x86"` | no |
| <a name="input_management_plan"></a> [management\_plan](#input\_management\_plan) | Which plan to use for the windows management host. | `string` | `"m3.small.x86"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | The public IP address of the bastion host. |
| <a name="output_management_password"></a> [management\_password](#output\_management\_password) | Randomly generated password used for the Admin accounts on the management host. |
| <a name="output_management_public_ip"></a> [management\_public\_ip](#output\_management\_public\_ip) | The public IP address of the windows management host. |
| <a name="output_next_steps"></a> [next\_steps](#output\_next\_steps) | Instructions for accessing the management host. |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | SSH Private key to use to connect to bastion and management hosts over SSH. |
<!-- END_TF_DOCS -->
