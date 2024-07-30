## Provision ESXi hosts
resource "equinix_metal_device" "esx" {
  timeouts {
    create = "60m"
  }
  hostname          = var.esxi_name
  project_id        = var.project_id
  metro             = var.metro
  plan              = var.device_plan
  operating_system  = var.esxi_version
  billing_cycle     = var.billing_cycle
  custom_data = jsonencode({
    sshd = {
      enabled = true
      pwauth = true
    }
    rootpwcrypt = var.esxi_pw
    esxishell = {
       enabled = true
    }
    kickstart = {
      firstboot_shell = "/bin/sh -C"
      firstboot_shell_cmd = <<EOT
sed -i '/^exit*/i /vmfs/volumes/datastore1/configpost.sh' /etc/rc.local.d/local.sh;
sed -i 's/passwordauthentication no/PasswordAuthentication yes/gI' /etc/ssh/sshd_config;
touch /vmfs/volumes/datastore1/configpost.sh;
chmod 755 /vmfs/volumes/datastore1/configpost.sh;
echo '#!/bin/sh' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip dns server add --server=${var.esxi_dns}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip dns search add --domain=${var.esxi_domain}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli system hostname set -H=${var.esxi_name}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli system hostname set -f=${var.esxi_name}.${var.esxi_domain}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli system ntp set -s=${var.esxi_ntp} >> /etc/ntp.conf' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli system ntp set -e=yes' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network vswitch standard portgroup set --portgroup-name="Management Network" --vlan-id=${var.esxi_mgmtvlan}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network vswitch standard portgroup set --portgroup-name="VM Network" --vlan-id=${var.vm-mgmt_vlan}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip interface remove --portgroup-name "Private Network"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network vswitch standard portgroup remove --portgroup-name "Private Network"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip interface remove --portgroup-name "BMC_Network"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network vswitch standard remove --vswitch-name "vSwitchBMC"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-advcfg -s 0 /Net/BMCNetworkEnable"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip interface ipv4 set -i vmk0 -I ${var.esxi_ip} -N ${var.esxi_subnet} -g ${var.esxi_gateway} -t static' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-route ${var.esxi_gateway}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'cd /etc/vmware/ssl' >> /vmfs/volumes/datastore1/configpost.sh;
echo '/sbin/generate-certificates' >> /vmfs/volumes/datastore1/configpost.sh;
echo '/etc/init.d/hostd restart && /etc/init.d/vpxa restart' >> /vmfs/volumes/datastore1/configpost.sh;
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
  vlan_ids = var.assigned_vlans
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
  vlan_ids = var.assigned_vlans
  bonded = false
}