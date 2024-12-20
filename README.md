# VMware VCF Cluster on Equinix Metal

[![run-pre-commit-hooks](https://github.com/equinix-labs/terraform-equinix-metal-vcf/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/equinix-labs/terraform-equinix-metal-vcf/actions/workflows/pre-commit.yaml)
[![generate-terraform-docs](https://github.com/equinix-labs/terraform-equinix-metal-vcf/actions/workflows/documentation.yaml/badge.svg)](https://github.com/equinix-labs/terraform-equinix-metal-vcf/actions/workflows/documentation.yaml)

`terraform-equinix-metal-vcf` is a minimal Terraform module that utilizes the [Terraform provider for Equinix](https://registry.terraform.io/namespaces/equinix) to provision, configure and setup an Equinix Metal hardware environment with the pre-requisites for a VCF 5.1.1 installation.

## Network Architecture Diagram

<img src="assets/1-VCF_on_Metal_ft_Metal_VRF.png" width="608" height="552" alt="Target Metal Architecture featuring Metal VRF for Underlay routing">

## Usage

This project is supported by the user community. Equinix does not provide support for this project.

This project may be forked, cloned, or downloaded and modified as needed as the base in your integrations and deployments.

This project may also be used as a [Terraform module](https://learn.hashicorp.com/collections/terraform/modules).

To use this module in a new project, create a file such as: [examples/vcf_management_domain/main.tf](./examples/vcf_management_domain/main.tf).

## Pre-Requisites

### Please note the following Requirement Specifics from VCF Cloud Builder

#### Physical Network

* DHCP with an appropriate scope size (one IP per physical NIC per host) is configured for the ESXi Host Overlay (TEP) network. Providing static IP pool is also supported but some Day-N operations like stretching a cluster will not be allowed if static IPs are used.

  * **Note:** Equinix Metal doesn't currently provide DHCP or DHCP relay. If DHCP is desired for TEP port IP assignment, this must be provided by some other instance(s) with the Overlay VLANs assigned.

#### Physical Hardware and ESXi Host

* Hardware and firmware (including HBA and BIOS) is configured for vSAN.
  * **Note:** The Equinix Support team can assist with ensuring that BIOS configuration is brought into compliance with vSAN recommendations should it be discovered that this is not already the case.

* Physical hardware health status is 'healthy' without any errors.
  * **Note:** The Equinix Support team can assist with ensuring hardware is brought into a healthy state should it be discovered otherwise.

#### Supporting Infrastructure

* DNS server for name resolution. Management IP of hosts is registered and queryable as both a forward (hostname-to-IP), and reverse (IP-to-Hostname) entry.
  * **Note:** While this module does configure the user provided DNS server details, the provided DNS server IP must be reachable by the Metal Instances through VRF Interconnection and the provided DNS server is meant for demo or Proof of Concept purposes only

---

### This module _does_ provide for the following VCF Infrastructure configuration as required by Cloud Builder

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

## Module Customization Overview

### Download Cloud Builder Deployment Parameter Guide spreadsheet from Broadcom

* [VCF 5.1.1 Release Downloads](https://support.broadcom.com/group/ecx/productfiles?subFamily=VMware%20Cloud%20Foundation&displayGroup=VMware%20Cloud%20Foundation%205.1&release=5.1.1&os=&servicePk=208634&language=EN)

<img src="assets/2-VCF_5.1.1_Downloads.png" width="336" height="293" alt="Broadcom Support Site - VCF 5.1.1 Downloads">

### Clone repo

* `git clone git@github.com:equinix-labs/terraform-equinix-metal-vcf.git`

### Copy and Modify tfvars file

#### Customize and align CLoud Builder Deployment Parameter Guide spreadsheet and tfvars files

* Copy the `terraform.tfvars.example` file to `terraform.tfvars`

  * Fill in Metal API Key, Project ID, and deployment Metro variables on lines [2](https://github.com/equinix-labs/terraform-equinix-metal-vcf/blob/ab13ea8e370a5140384bd91adbcf77375305b237/terraform.tfvars.example#L2), [3](https://github.com/equinix-labs/terraform-equinix-metal-vcf/blob/ab13ea8e370a5140384bd91adbcf77375305b237/terraform.tfvars.example#L3), and [6](https://github.com/equinix-labs/terraform-equinix-metal-vcf/blob/ab13ea8e370a5140384bd91adbcf77375305b237/terraform.tfvars.example#L6) respectively.
    * **Note:** there are more secure methods of implementing the API key, but that's out of scope for this readme

  * If interconnecting VRF Fabric VCs to BGP Neighbor(s), Fill in eBGP Peering details for VRF on lines [8-21](https://github.com/equinix-labs/terraform-equinix-metal-vcf/blob/ab13ea8e370a5140384bd91adbcf77375305b237/terraform.tfvars.example#L8) of the tfvars file.

  * Fill in the same values you used in the vcf-ems-deployment-parameter_X.X.X spreadsheet.
    * **Note:** that defined variables in variables.tf file have descriptions indicating the spreasheet cell that should have aligned values. Default values in the `terraform.tfvars.example` file should align with the defaults in the Deployment Parameter spreadsheet.

    * For more about the "Cloud Builder Deployment Parameter Guide" spreadsheet file and its configuration, see [About the Deployment Parameter Workbook on docs.vmware.com](https://docs.vmware.com/en/VMware-Cloud-Foundation/5.1/vcf-deploy/GUID-08E5E911-7B4B-4E1C-AE9B-68C90124D1B9.html) (requires a login and entitlements).

#### Generating custom root password

To generate a password hash of your desired ESXi root password run the 'mkpasswd' command on a Linux system with the 'whois' package installed as follows

```shell
mkpasswd --method=SHA-512
```

You'll be prompted to enter the desired password sting you wish to hash, then press enter.

<img src="assets/3-mkpasswd_example.png" width="540" height="47" alt="mkpasswd command Example">

Alternatively, you can instead use [mkpasswd.net](https://www.mkpasswd.net/) to generate a pasword hash. Be sure to select `crypt-sha512` in the `Type` dropdown.

<img src="assets/4-mkpasswd.net.png" width="294" height="126" alt="mkpasswd.net Site">
<img src="assets/5-mkpasswd.net_example.png" width="294" height="126" alt="mkpasswd.net Example">

The output will be the string you need to use in the `esxi_password` variable at line [143](https://github.com/equinix-labs/terraform-equinix-metal-vcf/blob/ab13ea8e370a5140384bd91adbcf77375305b237/terraform.tfvars.example#L143) of the `terraform.tfvars.example` file

## Terraform Deployment Workflow

### Deployment

* Deploy this Terraform module by running `terraform init -upgrade` and `terraform apply`.

* Note the following values that you'll need later:
  * The public IP address of the bastion host: `terraform output -raw bastion_public_ip`
  * The private IP address of the bastion host: `terraform output -raw bastion_private_ip`
  * The public IP address of the management host: `terraform output -raw windows_management_rdp_address`
  * The password for the management host: `terraform output -raw windows_management_password`
  * The DNS address of the ESX01 host: `terraform output -raw esx01_vmk0_address`

* The following steps should be run on the management host.
  * RDP to the public IP of management host you noted earlier.
    * Username: `SYSTEM\Admin`
    * Password: Use the password you noted earlier. (`terraform output -raw management_password`)

  * Download the Cloud Builder OVA from VMware
    * [VCF 5.1.1 Release Downloads](https://support.broadcom.com/group/ecx/productfiles?subFamily=VMware%20Cloud%20Foundation&displayGroup=VMware%20Cloud%20Foundation%205.1&release=5.1.1&os=&servicePk=208634&language=EN)

      <img src="assets/6-VCF_5.1.1_Download_OVA.png" width="336" height="293" alt="Broadcom Support Site - VCF 5.1.1 Downloads">

  * Log in to one of the ESXi hosts
    * Use the DNS address of the ESX01 host you noted earlier. (Our example uses: <https://sfo01-m01-esx01.sfo.rainpole.io>)
    * Username: `root`
    * Password: the custom root password you used to generate the hash earlier.

  * Deploy Cloud Builder OVA to one of the ESXi devices provisioned by Terraform, we recommend following VMware's documentation for this. <https://docs.vmware.com/en/VMware-Cloud-Foundation/5.1/vcf-deploy/GUID-78EEF782-CF21-4228-97E0-37B8D2165B81.html>
    * You will need to use the bastion host private IP you noted earlier as the DNS and NTP server during the OVA deployment.

  * Login to Cloud Builder at the address and username/password specified during OVA deployment.

  * Upload the vcf-ems-deployment-parameter spreadsheet to Cloud Builder when it asks for it.

  * Fix issues Cloud Builder finds.

  * Push deploy button and wait while VCF deploys.
    * **Note:** This process can take more than an hour to complete
    * If deploy fails, it is recommended to delete ESXi devices and re-deploy. Depending on where the process failed, Cloud Builder can end up leaving the ESXi devices config in an state that requires significant manual effort to clean-up before a subsequent attempt would pass the Cloud Builder pre-checks. Redeploying may be faster even if Cloud Builder must be re-deployed as well.

  * Create Interconnections to VRF and NSX-T Edge Uplinks by logging into Equinix Fabric and Redeeming the Fabric Service Tokens generated by this module
    * Management VRF Tokens: `terraform output -raw metal_vrf_interconnection_tokens`
    * NSX-T Uplink Tokens: `terraform output -raw nsxt_uplink_interconnection_tokens`
    * Create Fabric Connections redeeming these tokens as shown in the Equinix Fabric Documentation. <https://docs.equinix.com/en-us/Content/Interconnection/Fabric/service%20tokens/Fabric-create-connection-with-Zside.htm>

### Known issues

* `terraform destroy` sees timeout on "bastion" Metal Gateway resource as well as Metal VLANs.
  * This is a known issue because of the `null resource` used to configure BGP Dynamic Neighbor range on this Metal Gateway via curl command.
  * If the destroy operation times out, simply run `terraform destroy` again to successfully remove this resource.
    * **Note:** the "bastion" Metal Gateway resource is not required for a production deployment, only for PoCs where the "bastion" device is required to fulfill Cloud Builder prerequisites. Considerin removing the "bastion" device, gateway, and VLAN from the deployment if these prerequisites are satisfied by services accessible from VRF Interconnection uplinks.

### Cloud Builder deployment tips

* VMware OVF Tool can significantly speed up the deployment of the Cloud Builder appliance and allow for easily repeatable Cloud Builder deployment.
  * [OVF Tool Downloads on Broadcom Developer Portal](https://developer.broadcom.com/tools/open-virtualization-format-ovf-tool/latest)
  * Example OVF Tool command (windows):

```shell
.\ovftool.exe --name=cloudbuilder --X:injectOvfEnv --acceptAllEulas --noSSLVerify --diskMode=thin --datastore="datastore1" --net:'Network 1=VM Network' --powerOn --prop:guestinfo.ROOT_PASSWORD=VMwareDemo123! --prop:guestinfo.ADMIN_PASSWORD=VMwareDemo123! --prop:guestinfo.ip0=172.16.10.2 --prop:guestinfo.netmask0=255.255.255.0 --prop:guestinfo.gateway=172.16.10.1 --prop:guestinfo.hostname=cloudbuilder --prop:guestinfo.DNS=172.16.9.2 --prop:guestinfo.ntp=172.16.9.2 .\VMware-Cloud-Builder-5.1.1.0-23480823_OVF10.ova  vi://root:VMwareDemo123!@172.16.11.101
```

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
| <a name="input_bastion_ip"></a> [bastion\_ip](#input\_bastion\_ip) | IP address for the Bastion host | `string` | n/a | yes |
| <a name="input_cloudbuilder_ip"></a> [cloudbuilder\_ip](#input\_cloudbuilder\_ip) | IP address for the Cloudbuilder appliance | `string` | n/a | yes |
| <a name="input_esxi_devices"></a> [esxi\_devices](#input\_esxi\_devices) | Map containing individual ESXi device details for each Metal Instance | <pre>map(object({<br/>    name           = string               # Short form hostname of system (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I6:L6)<br/>    mgmt_ip        = string               # Management Network IP address for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I7:L7)<br/>    reservation_id = optional(string, "") # Hardware reservation IDs to use for the VCF nodes. Each item can be a reservation UUID or `next-available`.<br/>  }))</pre> | n/a | yes |
| <a name="input_esxi_management_gateway"></a> [esxi\_management\_gateway](#input\_esxi\_management\_gateway) | Management Network Gateway for ESXi default TCP/IP Stack (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > F8) | `string` | n/a | yes |
| <a name="input_esxi_management_subnet"></a> [esxi\_management\_subnet](#input\_esxi\_management\_subnet) | Management Network Subnet Mask for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > E8) | `string` | n/a | yes |
| <a name="input_esxi_network_space"></a> [esxi\_network\_space](#input\_esxi\_network\_space) | Overall Network space for the VCF project | `string` | n/a | yes |
| <a name="input_esxi_password"></a> [esxi\_password](#input\_esxi\_password) | mkpasswd Pre-hashed root password to be set for ESXi instances (Hash the password from vcf-ems-deployment-parameter.xlsx > Credentials Sheet > C8 using 'mkpasswd --method=SHA-512' from Linux whois package) | `string` | n/a | yes |
| <a name="input_esxi_plan"></a> [esxi\_plan](#input\_esxi\_plan) | Slug for target hardware plan type. The only officially supported server plan for ESXi/VCF is the 'n3.xlarge.opt-m4s2' https://deploy.equinix.com/product/servers/n3-xlarge-opt-m4s2/ | `string` | n/a | yes |
| <a name="input_esxi_version_slug"></a> [esxi\_version\_slug](#input\_esxi\_version\_slug) | Slug for ESXi OS version to be deployed on Metal Instances https://github.com/equinixmetal-images/changelog/blob/main/vmware-esxi/x86_64/8.md | `string` | n/a | yes |
| <a name="input_metal_auth_token"></a> [metal\_auth\_token](#input\_metal\_auth\_token) | API Token for Equinix Metal API interaction https://deploy.equinix.com/developers/docs/metal/identity-access-management/api-keys/ | `string` | n/a | yes |
| <a name="input_metal_project_id"></a> [metal\_project\_id](#input\_metal\_project\_id) | Equinix Metal Project UUID, can be found in the General Tab of the Organization Settings https://deploy.equinix.com/developers/docs/metal/identity-access-management/organizations/#organization-settings-and-roles | `string` | n/a | yes |
| <a name="input_metal_vrf_asn"></a> [metal\_vrf\_asn](#input\_metal\_vrf\_asn) | ASN to be used for Metal VRF https://deploy.equinix.com/developers/docs/metal/networking/vrf/ | `string` | n/a | yes |
| <a name="input_metro"></a> [metro](#input\_metro) | Equinix Metal Metro where Metal resources are going to be deployed https://deploy.equinix.com/developers/docs/metal/locations/metros/#metros-quick-reference | `string` | n/a | yes |
| <a name="input_nsx_devices"></a> [nsx\_devices](#input\_nsx\_devices) | Map containing NSX Cluster host and IP details | <pre>map(object({<br/>    name = string # Short form hostname of system (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I6:L6)<br/>    ip   = string # Management Network IP address for VMK0 (vcf-ems-deployment-parameter.xlsx > Hosts and Networks Sheet > I7:L7)<br/>  }))</pre> | n/a | yes |
| <a name="input_sddc_manager_ip"></a> [sddc\_manager\_ip](#input\_sddc\_manager\_ip) | IP address for the SDDC Manager | `string` | n/a | yes |
| <a name="input_sddc_manager_name"></a> [sddc\_manager\_name](#input\_sddc\_manager\_name) | Hostname for the SDDC Manager | `string` | n/a | yes |
| <a name="input_vcenter_ip"></a> [vcenter\_ip](#input\_vcenter\_ip) | IP address for the vCenter Server | `string` | n/a | yes |
| <a name="input_vcenter_name"></a> [vcenter\_name](#input\_vcenter\_name) | Hostname for the vCenter Server | `string` | n/a | yes |
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
| <a name="input_windows_management_ip"></a> [windows\_management\_ip](#input\_windows\_management\_ip) | IP address for the Windows management host | `string` | n/a | yes |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | DNS Zone name to use for deployment (vcf-ems-deployment-parameter.xlsx > Deploy Parameters Sheet > J6:K6) | `string` | n/a | yes |
| <a name="input_bastion_name"></a> [bastion\_name](#input\_bastion\_name) | Hostname for the Bastion host | `string` | `"bastion"` | no |
| <a name="input_bastion_plan"></a> [bastion\_plan](#input\_bastion\_plan) | Which plan to use for the ubuntu based bastion host. | `string` | `"m3.small.x86"` | no |
| <a name="input_cloudbuilder_name"></a> [cloudbuilder\_name](#input\_cloudbuilder\_name) | Hostname for the Cloudbuilder appliance | `string` | `"cloudbuilder"` | no |
| <a name="input_windows_management_name"></a> [windows\_management\_name](#input\_windows\_management\_name) | Hostname for the Windows management host | `string` | `"management"` | no |
| <a name="input_windows_management_plan"></a> [windows\_management\_plan](#input\_windows\_management\_plan) | Which plan to use for the windows management host. | `string` | `"m3.small.x86"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | The public IP address of the bastion host. Used for troubleshooting. |
| <a name="output_cloudbuilder_default_gateway"></a> [cloudbuilder\_default\_gateway](#output\_cloudbuilder\_default\_gateway) | Cloudbuilder Default Gateway to use during OVA deployment. |
| <a name="output_cloudbuilder_hostname"></a> [cloudbuilder\_hostname](#output\_cloudbuilder\_hostname) | Cloudbuilder Hostname to use during OVA deployment. |
| <a name="output_cloudbuilder_ip"></a> [cloudbuilder\_ip](#output\_cloudbuilder\_ip) | Cloudbuilder IP to use during OVA deployment. |
| <a name="output_cloudbuilder_subnet_mask"></a> [cloudbuilder\_subnet\_mask](#output\_cloudbuilder\_subnet\_mask) | Cloudbuilder Subnet Mask to use during OVA deployment. |
| <a name="output_cloudbuilder_web_address"></a> [cloudbuilder\_web\_address](#output\_cloudbuilder\_web\_address) | Cloudbuilder Web Address |
| <a name="output_dns_domain_name"></a> [dns\_domain\_name](#output\_dns\_domain\_name) | DNS Domain Name to use during OVA deployment. |
| <a name="output_dns_domain_search_paths"></a> [dns\_domain\_search\_paths](#output\_dns\_domain\_search\_paths) | DNS Domain Search Paths to use during OVA deployment. |
| <a name="output_dns_server"></a> [dns\_server](#output\_dns\_server) | DNS Server to use during OVA deployment. |
| <a name="output_esx01_web_address"></a> [esx01\_web\_address](#output\_esx01\_web\_address) | The web address of the first ESXi host to use in a browser on the management host. |
| <a name="output_ntp_server"></a> [ntp\_server](#output\_ntp\_server) | NTP Server to use during OVA deployment. |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | Path to the SSH Private key to use to connect to bastion and management hosts over SSH. |
| <a name="output_windows_management_password"></a> [windows\_management\_password](#output\_windows\_management\_password) | Randomly generated password used for the Admin accounts on the management host. |
| <a name="output_windows_management_rdp_address"></a> [windows\_management\_rdp\_address](#output\_windows\_management\_rdp\_address) | The public IP address of the windows management host. |
<!-- END_TF_DOCS -->

## Contributing

If you would like to contribute to this module, see [CONTRIBUTING](CONTRIBUTING.md) page.

## License

Apache License, Version 2.0. See [LICENSE](LICENSE).
