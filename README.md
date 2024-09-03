# terraform-equinix-template

[![run-pre-commit-hooks](https://github.com/equinix-labs/terraform-equinix-metal-vcf/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/equinix-labs/terraform-equinix-metal-vcf/actions/workflows/pre-commit.yaml)
[![generate-terraform-docs](https://github.com/equinix-labs/terraform-equinix-metal-vcf/actions/workflows/documentation.yaml/badge.svg)](https://github.com/equinix-labs/terraform-equinix-metal-vcf/actions/workflows/documentation.yaml)

`terraform-equinix-metal-vcf` is a minimal Terraform module that utilizes [Terraform providers for Equinix](https://registry.terraform.io/namespaces/equinix) to provision digital infrastructure and demonstrate higher level integrations.

<img src="assets/8-VCF_on_Metal_ft_Metal_VRF.png" width="608" height="552" alt="Target Metal Architecture featuring Metal VRF for Underlay routing">

## Usage

This project is supported by the user community. Equinix does not provide support for this project.

Install Terraform using the [tfenv](https://github.com/tfutils/tfenv) utility.

This project may be forked, cloned, or downloaded and modified as needed as the base in your integrations and deployments.

This project may also be used as a [Terraform module](https://learn.hashicorp.com/collections/terraform/modules).

To use this module in a new project, create a file such as:

```hcl
# main.tf
terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
    }
}

module "example" {
  source = "github.com/equinix-labs/terraform-equinix-metal-vcf"
  # Published modules can be sourced as:
  # source = "equinix-labs/terraform-equinix-metal-vcf/equinix"
  # See https://www.terraform.io/docs/registry/modules/publish.html for details.

  # version = "0.1.0"

  ## Metal Auth
  metal_auth_token      = ""  # API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/
  metal_project_id      = ""  # Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles

  ## Fabric/NE Auth
  fabric_client_id     = ""   # Client ID for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview
  fabric_client_secret = ""   # Client Secret for Equinix Fabric API interaction https://developer.equinix.com/docs?page=/dev-docs/fabric/overview

  # Metro for this deployment
  metro                 = ""  # Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference

  # Network Edge Device UUIDs and notification email for Metal VRF Interconnections
  primary_ne_device_uuid                  = ""   # UUID of Primary Network Edge Device for interconnection to Metal VRF
  secondary_ne_device_uuid                = ""   # UUID of Secondary Network Edge Device for interconnection to Metal VRF
  primary_ne_device_port                  = 3    # Port Number on Primary Network Edge Device for interconnection to Metal VRF
  secondary_ne_device_port                = 3    # Port Number on Secondary Network Edge Device for interconnection to Metal VRF
  vrf_interconnection_speed               = 200  # Metal VRF interconnection speed
  vrf_interconnection_notification_email  = ""   # Email address for interconnection notifications

  # Metal VRF ASN
  metal_vrf_asn   = "65100"

  ## Metal VRF Peering details for Interconnection Uplinks
  vrf_peer_subnet               = "172.31.255.0/29" # Subnet used for both Metal VRF interconnections (/29 or larger)
  vrf_peer_asn                  = "65534"           # ASN that will establish BGP Peering with the Metal VRF across the interconnections
  vrf_peer_subnet-pri           = "172.31.255.0/30" # Subnet used for point to point connection across the Primary interconnection
  vrf_bgp_customer_peer_ip-pri  = "172.31.255.2"    # IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with
  vrf_bgp_metal_peer_ip-pri     = "172.31.255.1"    # IP of Metal VRF on Primary Interconnect for peering with BGP Neighbor
  vrf_bgp_md5-pri               = ""                # MD5 Shared Password for BGP Session authentication
  vrf_peer_subnet-sec           = "172.31.255.4/30" # Subnet used for point to point connection across the Primary interconnection
  vrf_bgp_customer_peer_ip-sec  = "172.31.255.6"    # IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with
  vrf_bgp_metal_peer_ip-sec     = "172.31.255.5"    # IP of Metal VRF on Primary Interconnect for peering with BGP Neighbor
  vrf_bgp_md5-sec               = ""                # MD5 Shared Password for BGP Session authentication

  ## VLAN and Metal Gateway provisioning with VRF Subnets and
  ## Optional Dynamic Neighbor Ranges for BGP Peering with the
  ## Metal VRF from inside the Metal Project
  ## 2712" = {
  ##      vlan_id         = "2712"                # 802.1q VLAN number
  ##      vlan_name       = "NSXt_Edge_Uplink2"   # Preferred Description of Metal VLAN
  ##      subnet          = "172.27.12.0/24"      # Subnet to be used within this Metal VLAN
  ##      enable_dyn_nei  = true                  # Whether or not to configure BGP Dynamic Neighbor functionality on the gateway
  ##      dyn_nei_range   = "172.27.12.2/31"      # CIDR Range of IPs that the Metal VRF should expect BGP Peering from
  ##      dyn_nei_asn     = "65101"               # ASN that the Metal VRF should expect BGP Peering from
  vcf_vrf_networks = {
    "bastion" = {
      vlan_id        = "1609"
      vlan_name      = "Bastion_Network"
      subnet         = "172.16.9.0/24"
      enable_dyn_nei = true
      dyn_nei_range  = "172.16.9.2/31"
      dyn_nei_asn    = "65101"
    },
    "vm-mgmt" = {
      vlan_id   = "1610"
      vlan_name = "VM-Management_Network"
      subnet    = "172.16.10.0/24"
    },
    "mgmt" = {
      vlan_id   = "1611"
      vlan_name = "Management_Network"
      subnet    = "172.16.11.0/24"
    },
    "vMotion" = {
      vlan_id   = "1612"
      vlan_name = "vMotion_Network"
      subnet    = "172.16.12.0/24"
    },
    "vSAN" = {
      vlan_id   = "1613"
      vlan_name = "vSAN_Network"
      subnet    = "172.16.13.0/24"
    },
    "NSXt" = {
      vlan_id   = "1614"
      vlan_name = "NSXt_Host_Overlay"
      subnet    = "172.16.14.0/24"
    },
    "NSXt_Edge" = {
      vlan_id   = "2713"
      vlan_name = "NSXt_Edge_overlay"
      subnet    = "172.27.13.0/24"
    },
    "NSXt_Uplink1" = {
      vlan_id        = "2711"
      vlan_name      = "NSXt_Edge_Uplink1"
      subnet         = "172.27.11.0/24"
      enable_dyn_nei = true
      dyn_nei_range  = "172.27.11.2/31"
      dyn_nei_asn    = "65101"
    },
    "NSXt_Uplink2" = {
      vlan_id        = "2712"
      vlan_name      = "NSXt_Edge_Uplink2"
      subnet         = "172.27.12.0/24"
      enable_dyn_nei = true
      dyn_nei_range  = "172.27.12.2/31"
      dyn_nei_asn    = "65101"
    }
  }

  ## ESXi individual device details
  ## "sfo01-m01-esx01" = {
  ##     name         = "sfo01-m01-esx01"   # Short form hostname of system
  ##     mgmt_ip      = "172.16.11.101"     # Management Network IP address for VMK0
  ##    reservation_id = "next-available" # Hardware reservation IDs to use for the VCF nodes. Each item can be a reservation UUID or `next-available`.
  esxi_devices = {
    "sfo01-m01-esx01" = {
      name         = "sfo01-m01-esx01"
      mgmt_ip      = "172.16.11.101"
    },
    "sfo01-m01-esx02" = {
      name         = "sfo01-m01-esx02"
      mgmt_ip      = "172.16.11.102"
    },
    "sfo01-m01-esx03" = {
      name         = "sfo01-m01-esx03"
      mgmt_ip      = "172.16.11.103"
    },
    "sfo01-m01-esx04" = {
      name         = "sfo01-m01-esx04"
      mgmt_ip      = "172.16.11.104"
    }
  }

  ## ESXi device common details
  esxi_network_space = "172.16.0.0/16"
  esxi_management_subnet    = "255.255.255.0"        # Management Network Subnet Mask for VMK0
  esxi_management_gateway   = "172.16.11.1"          # Management Network Gateway for default TCP/IP Stack
  esxi_dns_server           = "172.16.1.1"           # DNS Server to be configured in ESXi
  esxi_domain               = "sfo.rainpole.io"      # Domain Name to be configured in ESXi FQDN along with name above
  esxi-mgmt_vlan            = "1611"                 # VLAN ID of Management VLAN for ESXi Management Network portgroup/VMK0
  esxi_ntp_server           = "172.16.1.1"           # NTP Server to be configured in ESXi
  esxi_password             = ""                     # Pre-hashed root password to be set for ESXi instances https://github.com/equinix-labs/terraform-equinix-metal-vcf?tab=readme-ov-file#custom-root-password
  esxi_plan                 = "n3.xlarge.x86-m4s2"   # Slug for target hardware plan type. The only officially supported server plan for ESXi/VCF is the 'n3.xlarge.opt-m4s2' https://deploy.equinix.com/product/servers/n3-xlarge-opt-m4s2/
  esxi_version_slug         = "vmware_vcf_5_1"       # Slug for ESXi OS version to be deployed on Metal Instances https://github.com/equinixmetal-images/changelog/blob/main/vmware-esxi/x86_64/8.md
  billing_cycle             = "hourly"               # The billing cycle of the device ('hourly', 'daily', 'monthly', 'yearly') when in doubt, use 'hourly'

  ## Management Host Details
  management_plan = "m3.small.x86"
  bastion_plan = "m3.small.x86"

}
```

Install [pre-commit](https://pre-commit.com/#install) with its prerequesites: [python](https://docs.python.org/3/using/index.html) and [pip](https://pip.pypa.io/en/stable/installation/).

Configure pre-commit: `pre-commit install`.

Install required packages: [tflint](https://github.com/terraform-linters/tflint), [tfsec](https://aquasecurity.github.io/tfsec/v1.0.11/getting-started/installation/), [shfmt](https://github.com/mvdan/sh), [shellcheck](https://github.com/koalaman/shellcheck), and [markdownlint](https://github.com/markdownlint/markdownlint).

Run `terraform init -upgrade` and `terraform apply`.

## Module Documentation

The main README.md, the modules README.md and the examples README.md are populated by [terraform-docs worflow job](.github/workflows/documentation.yaml). The following sections are appended between the terraform-docs delimeters: Requiremenents, Providers, Modules, Resources, Inputs, and Outputs.

## Module Release and Changelog Generation

The module git release and [changelog](CHANGELOG.md) are generated by the [release workflow job](.github/workflows/release.yaml). The release worflow follows the [conventional commits convention](https://www.conventionalcommits.org/). To submit a commit, please follow the [commit message format guidelines](https://www.conventionalcommits.org/en/v1.0.0/#specification). This job is set to run manually by default.

Example commit message: `fix: disabled log generation for system services`

For more examples, please see [conventional commit message examples](https://www.conventionalcommits.org/en/v1.0.0/#examples).

## Examples

To view examples for how you can leverage this module, please see the [examples](examples/) directory.

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
| <a name="module_metal_vrf"></a> [metal\_vrf](#module\_metal\_vrf) | ./modules/metal_vrf_w_interconnection_service_tokens | n/a |
| <a name="module_metal_vrf_gateways_w_dynamic_neighbor"></a> [metal\_vrf\_gateways\_w\_dynamic\_neighbor](#module\_metal\_vrf\_gateways\_w\_dynamic\_neighbor) | ./modules/metal_vrf_gateway_w_dynamic_neighbor | n/a |
| <a name="module_ssh"></a> [ssh](#module\_ssh) | ./modules/ssh/ | n/a |
| <a name="module_vcf_metal_devices"></a> [vcf\_metal\_devices](#module\_vcf\_metal\_devices) | ./modules/vcf_metal_device | n/a |

## Resources

| Name | Type |
|------|------|
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
| <a name="input_esxi_devices"></a> [esxi\_devices](#input\_esxi\_devices) | Map containing individual ESXi device details for each Metal Instance | <pre>map(object({<br/>    name           = string               # Short form hostname of system (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I6:L6)<br/>    mgmt_ip        = string               # Management Network IP address for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I7:L7)<br/>    reservation_id = optional(string, "") # Hardware reservation IDs to use for the VCF nodes. Each item can be a reservation UUID or `next-available`.<br/>  }))</pre> | n/a | yes |
| <a name="input_esxi_dns_server"></a> [esxi\_dns\_server](#input\_esxi\_dns\_server) | DNS Server to be configured in ESXi (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > F6:G6) | `string` | n/a | yes |
| <a name="input_esxi_domain"></a> [esxi\_domain](#input\_esxi\_domain) | Domain Name to be configured in ESXi FQDN along with name in Map above (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > J6:K6) | `string` | n/a | yes |
| <a name="input_esxi_management_gateway"></a> [esxi\_management\_gateway](#input\_esxi\_management\_gateway) | Management Network Gateway for ESXi default TCP/IP Stack (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > F8) | `string` | n/a | yes |
| <a name="input_esxi_management_subnet"></a> [esxi\_management\_subnet](#input\_esxi\_management\_subnet) | Management Network Subnet Mask for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > E8) | `string` | n/a | yes |
| <a name="input_esxi_mgmt_vlan"></a> [esxi\_mgmt\_vlan](#input\_esxi\_mgmt\_vlan) | VLAN ID of Management VLAN for ESXi Management Network portgroup/VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > C8) | `string` | n/a | yes |
| <a name="input_esxi_network_space"></a> [esxi\_network\_space](#input\_esxi\_network\_space) | Overall Network space for the VCF project | `string` | n/a | yes |
| <a name="input_esxi_ntp_server"></a> [esxi\_ntp\_server](#input\_esxi\_ntp\_server) | NTP Server to be configured in ESXi (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > F8:G8) | `string` | n/a | yes |
| <a name="input_esxi_password"></a> [esxi\_password](#input\_esxi\_password) | mkpasswd Pre-hashed root password to be set for ESXi instances (Hash the password from vcf-ems-deployment-parameter.xlsx > Credentials Sheet > C8 using 'mkpasswd --method=SHA-512' from Linux whois package) | `string` | n/a | yes |
| <a name="input_esxi_plan"></a> [esxi\_plan](#input\_esxi\_plan) | Slug for target hardware plan type. The only officially supported server plan for ESXi/VCF is the 'n3.xlarge.opt-m4s2' https://deploy.equinix.com/product/servers/n3-xlarge-opt-m4s2/ | `string` | n/a | yes |
| <a name="input_esxi_version_slug"></a> [esxi\_version\_slug](#input\_esxi\_version\_slug) | Slug for ESXi OS version to be deployed on Metal Instances https://github.com/equinixmetal-images/changelog/blob/main/vmware-esxi/x86_64/8.md | `string` | n/a | yes |
| <a name="input_metal_auth_token"></a> [metal\_auth\_token](#input\_metal\_auth\_token) | API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/ | `string` | n/a | yes |
| <a name="input_metal_project_id"></a> [metal\_project\_id](#input\_metal\_project\_id) | Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles | `string` | n/a | yes |
| <a name="input_metal_vrf_asn"></a> [metal\_vrf\_asn](#input\_metal\_vrf\_asn) | ASN to be used for Metal VRF https://deploy.equinix.com/developers/docs/metal/networking/vrf/ | `string` | n/a | yes |
| <a name="input_metro"></a> [metro](#input\_metro) | Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference | `string` | n/a | yes |
| <a name="input_vcf_vrf_networks"></a> [vcf\_vrf\_networks](#input\_vcf\_vrf\_networks) | Map of Objects representing configuration specifics for various network segments required for VCF Management and Underlay Networking | <pre>map(object({<br/>    vlan_id        = string                # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > C7:C10) 802.1q VLAN number<br/>    vlan_name      = string                # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > D7:D10) Preferred Description of Metal VLAN<br/>    subnet         = string                # (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > E7:E10) CIDR Subnet to be used within this Metal VLAN<br/>    enable_dyn_nei = optional(bool, false) # Whether or not to configure BGP Dynamic Neighbor functionality on the gateway, only use for NSX-t Edge uplink VLANs if NSX-t will peer with Metal VRF<br/>    dyn_nei_range  = optional(string, "")  # CIDR Range of IPs that the Metal VRF should expect BGP Peering from<br/>    dyn_nei_asn    = optional(string, "")  # ASN that the Metal VRF should expect BGP Peering from<br/>  }))</pre> | n/a | yes |
| <a name="input_vrf_bgp_customer_peer_ip_pri"></a> [vrf\_bgp\_customer\_peer\_ip\_pri](#input\_vrf\_bgp\_customer\_peer\_ip\_pri) | IP of BGP Neighbor on Primary Interconnection that Metal VRF should expect to peer with | `string` | n/a | yes |
| <a name="input_vrf_bgp_customer_peer_ip_sec"></a> [vrf\_bgp\_customer\_peer\_ip\_sec](#input\_vrf\_bgp\_customer\_peer\_ip\_sec) | IP of BGP Neighbor on Secondary Interconnection that Metal VRF should expect to peer with | `string` | n/a | yes |
| <a name="input_vrf_bgp_md5_pri"></a> [vrf\_bgp\_md5\_pri](#input\_vrf\_bgp\_md5\_pri) | MD5 Shared Password for BGP session authentication | `string` | n/a | yes |
| <a name="input_vrf_bgp_md5_sec"></a> [vrf\_bgp\_md5\_sec](#input\_vrf\_bgp\_md5\_sec) | MD5 Shared Password for BGP session authentication | `string` | n/a | yes |
| <a name="input_vrf_bgp_metal_peer_ip_pri"></a> [vrf\_bgp\_metal\_peer\_ip\_pri](#input\_vrf\_bgp\_metal\_peer\_ip\_pri) | IP of Metal VRF on Primary Interconnection for peering with BGP Neighbor | `string` | n/a | yes |
| <a name="input_vrf_bgp_metal_peer_ip_sec"></a> [vrf\_bgp\_metal\_peer\_ip\_sec](#input\_vrf\_bgp\_metal\_peer\_ip\_sec) | IP of Metal VRF on Secondary Interconnection for peering with BGP Neighbor | `string` | n/a | yes |
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

## Contributing

If you would like to contribute to this module, see [CONTRIBUTING](CONTRIBUTING.md) page.

## License

Apache License, Version 2.0. See [LICENSE](LICENSE).

## Pre-Requisites

### You are responsible for the following

#### Physical Network

* DHCP with an appropriate scope size (one IP per physical NIC per host) is configured for the ESXi Host Overlay (TEP) network. Providing static IP pool is also supported but some Day-N operations like stretching a cluster will not be allowed if static IPs are used.

#### Physical Hardware and ESXi Host

* Hardware and firmware (including HBA and BIOS) is configured for vSAN.
  * **Note:** The Equinix Support team can assist with ensuring that BIOS configuration is brought into compliance with vSAN recommendations should it be discovered that this is not already the case.

* Physical hardware health status is 'healthy' without any errors.

  * **Note:** The Equinix Support team can assist with ensuring hardware is brought into a healthy state should it be discovered otherwise.

* ~~All hosts are in synchronization with a central time server (NTP).~~

  * ~~**Note:** While this module does configure the user provided NTP server details, the provided NTP server IP must be reachable by the Metal Instances through VRF Interconnection.~~

#### Supporting Infrastructure

* DNS server for name resolution. Management IP of hosts is registered and queryable as both a forward (hostname-to-IP), and reverse (IP-to-Hostname) entry.
  * **Note:** While this module does configure the user provided DNS server details, the provided DNS server IP must be reachable by the Metal Instances through VRF Interconnection.

---

### This module _does_ provide for the following VCF Infrastructure requirements as required by Cloud Builder

#### Network

* Top of Rack switches are configured. Each host and NIC in the management domain must have the same network configuration. No ethernet link aggregation technology (LAG/VPC/LACP) is being used.

* IP ranges, subnet mask, and a reliable L3 (default) gateway for each VLAN are provided.

* Jumbo Frames (MTU 9000) are recommended on all VLANs. At a minimum, MTU of 1600 is required on the NSX Host Overlay VLAN and must be enabled end to end through your environment.

* VLANs for management, vMotion, vSAN and NSX Host Overlay networks are created and tagged to all host ports. Each VLAN is 802.1q tagged.

* Management IP is VLAN backed and configured on the host. vMotion & vSAN IP ranges are configured during the bring-up process.

#### Hardware and ESXi Hosts

* All servers are vSAN compliant and certified on the VMware Hardware Compatibility Guide, including but not limited to BIOS, HBA, SSD, HDD, etc.

* Identical hardware (CPU, Memory, NICs, SSD/HDD, etc.) within the management cluster is highly recommended. Refer to vSAN documentation for minimal configuration.

* One physical NIC is configured and connected to the vSphere Standard switch. The second physical NIC is not configured.

* ESXi is freshly installed on each host. The ESXi version matches the build listed in the Cloud Foundation Bill of Materials.

* All hosts are configured with a central time server (NTP). NTP service policy set to 'Start and stop with host'.

* Each ESXi host is running a non-expired license - initial evaluation license is accepted. The bring-up process will configure the permanent license provided.

#### Other Infrastructure

* All hosts are configured with a DNS server for name resolution.

## Custom root password

### Generating custom root password

To generate a password hash of your desired ESXi root password run the 'mkpasswd' command on a Linux system with the 'whois' package installed as follows

```shell
mkpasswd --method=SHA-512
```

You'll be prompted to enter the desired password sting you wish to hash, then press enter.

![Alt text](assets/9-mkpasswd_example.png "mkpasswd Example")

The output will be the string you need to use in the esxi_password variable near the end of the terraform.tfvars.example file

## Terraform Deployment Workflow

### Preparation

* Download the vcf-ems-deployment-parameter_X.X.X spreadsheet for the VCF version you're deploying from VMware and fill it out for your environment.
* Copy the terraform.tfvars.example file to terraform.tfvars and fill it with the same values you used in the vcf-ems-deployment-parameter_X.X.X spreadsheet.

### Deployment

* Deploy this Terraform module
* RDP to the management host
  * Username: `SYSTEM\Admin`
  * Password: provided in the terraform output `terraform output -raw management_password`.
* Download the Cloudbuilder OVA from VMware
* Log in to one of the ESXi hosts
  * <https://sfo01-m01-esx01.sfo.rainpole.io>
* Deploy Cloudbuilder OVA on ESXi
* Login to cloudbuilder at <https://172.16.9.3> with admin/<the password you chose>
* Upload the vcf-ems-deployment-parameter spreadsheet to cloudbuilder when it asks for it.
* Fix issues cloudbuilder finds.
* Push deploy button and wait an hour or two as VCF deploys.
