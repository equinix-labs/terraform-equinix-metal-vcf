## Provision ESXi hosts
resource "equinix_metal_device" "esx" {
  timeouts {
    create = "60m"
  }
  hostname          = var.esxi_hostname
  project_id        = var.metal_project_id
  metro             = var.metal_metro
  plan              = var.metal_device_plan
  operating_system  = var.esxi_version_slug
  billing_cycle     = var.metal_billing_cycle
  custom_data = jsonencode({
    sshd = {
      enabled = true
      pwauth = true
    }
    rootpwcrypt = var.esxi_password
    esxishell = {
       enabled = true
    }
    kickstart = {
      firstboot_shell = "/bin/sh -C"
      firstboot_shell_cmd = <<EOT
sed -i '/^exit*/i /vmfs/volumes/datastore1/configpost.sh' /etc/rc.local.d/local.sh;
touch /vmfs/volumes/datastore1/configpost.sh;
chmod 755 /vmfs/volumes/datastore1/configpost.sh;
echo '#!/bin/sh' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip dns server add --server=${var.esxi_dns_server}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip dns search add --domain=${var.esxi_domain}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli system hostname set -H=${var.esxi_hostname}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli system hostname set -f=${var.esxi_hostname}.${var.esxi_domain}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli system ntp set -s=${var.esxi_ntp_server} >> /etc/ntp.conf' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli system ntp set -e=yes' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network vswitch standard portgroup set --portgroup-name="Management Network" --vlan-id=${var.esxi-mgmt_vlan}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network vswitch standard portgroup set --portgroup-name="VM Network" --vlan-id=${var.vm-mgmt_vlan}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip interface remove --portgroup-name "Private Network"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network vswitch standard portgroup remove --vswitch-name="vSwitch0" --portgroup-name="Private Network"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip interface remove --portgroup-name "BMC_Network"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network vswitch standard remove --vswitch-name "vSwitchBMC"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-advcfg -s 0 /Net/BMCNetworkEnable' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip interface ipv4 set -i vmk0 -I ${var.esxi_management_ip} -N ${var.esxi_management_subnet} -g ${var.esxi_management_gateway} -t static' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-route ${var.esxi_management_gateway}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'cd /etc/vmware/ssl' >> /vmfs/volumes/datastore1/configpost.sh;
echo '/sbin/generate-certificates' >> /vmfs/volumes/datastore1/configpost.sh;
echo '/etc/init.d/hostd restart && /etc/init.d/vpxa restart' >> /vmfs/volumes/datastore1/configpost.sh;
echo "sed -i 's/passwordauthentication no/PasswordAuthentication yes/gI' /etc/ssh/sshd_config;" >> /vmfs/volumes/datastore1/configpost.sh;
echo '/etc/init.d/SSH restart' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'sed -i '/configpost.sh/d' /etc/rc.local.d/local.sh' >> /vmfs/volumes/datastore1/configpost.sh
EOT
      postinstall_shell = "/bin/sh -C"
      postinstall_shell_cmd = ""
    }
  })
}

## Configure VLANs on server eth0
resource "equinix_metal_port" "eth0" {
  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
  depends_on = [equinix_metal_device.esx]
  port_id = [for p in equinix_metal_device.esx.ports : p.id if p.name == "eth0"][0]
  vlan_ids = var.esxi_assigned_vlans
  bonded = false
}

## Configure VLANs on server eth1
resource "equinix_metal_port" "eth1" {
  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
  depends_on = [equinix_metal_port.eth0]
  port_id = [for p in equinix_metal_device.esx.ports : p.id if p.name == "eth1"][0]
  vlan_ids = var.esxi_assigned_vlans
  bonded = false
}

## Configure VLANs on server eth2
resource "equinix_metal_port" "eth2" {
  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
  depends_on = [equinix_metal_device.esx]
  port_id = [for p in equinix_metal_device.esx.ports : p.id if p.name == "eth2"][0]
  vlan_ids = var.esxi_assigned_vlans
  bonded = false
}

## Configure VLANs on server eth3
resource "equinix_metal_port" "eth3" {
  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
  depends_on = [equinix_metal_port.eth0]
  port_id = [for p in equinix_metal_device.esx.ports : p.id if p.name == "eth3"][0]
  vlan_ids = var.esxi_assigned_vlans
  bonded = false
}