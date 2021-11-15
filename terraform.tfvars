auth_token      = "your-API-token"
project_id      = "your-project-ID"

# Metro for this stack
metro         = "da"

# VLAN provisioning
vlans = [
    {
      vxlan = "1611"
      name = "Management_Network"
    },
    {
      vxlan = "1612"
      name = "vMotion Network"
    },
    {
      vxlan = "1613"
      name = "vSAN Network"
    },
    {
      vxlan = "1614"
      name = "NSXt_Host_Overlay"
    },
    {
      vxlan = "2711"
      name = "NSXt_Edge_Uplink1"
    },
    {
      vxlan = "2712"
      name = "NSXt_Edge_Uplink2"
    },
    {
      vxlan = "2713"
      name = "NSXt_Edge_overlay"
    }
]

## EDGE PROVISIONING VARS ##
# Routed IP block size /29=8 /28=16 /27=32
public_ips_net = "8"
edge_hostname = "vcf-edge-gateway"
edge_size     = "c3.small.x86"
edge_os       = "ubuntu_20_04"
pub_ip         = ""

## ESX PROVISIONING VARS ##
esx_names = [
 {esxname = "sfo01-m01-esx01"},
 {esxname = "sfo01-m01-esx02"},
 {esxname = "sfo01-m01-esx03"},
 {esxname = "sfo01-m01-esx04"}
]
esx_ips = [
 {esxip = "172.16.11.101"},
 {esxip = "172.16.11.102"},
 {esxip = "172.16.11.103"},
 {esxip = "172.16.11.104"}
]
esx_subnet    = "255.255.255.0"
esx_gateway   = "172.16.11.253"
esx_dns       = "172.16.11.4"
esx_domain    = "sfo.rainpole.io"
esx_mgmtvlan  = "1611"
esx_ntp       = "172.16.11.253"
esx_pw        = "$6$rounds=4096$H7lGcpu7$wwdCf1BOTdhGFoWlfNx9r3tkxmDuGYEGZmJMJ2Y1Quks6ps6Uv7aow5xrGJIzBG2zAZyu32UzZ5um2Gr40ac81"
esx_size      = "m3.large.x86"
vcf_version   = "vmware_esxi_7_0_vcf"
billing_cycle = "hourly"
