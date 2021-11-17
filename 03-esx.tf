# provision ESXi hosts

resource "metal_device" "esx" {
  count             = length(var.esx_names)
  hostname          = var.esx_names[count.index].esxname
  project_id        = var.project_id
  metro             = var.metro
  plan              = var.esx_size
  operating_system  = var.vcf_version
  billing_cycle     = var.billing_cycle
  custom_data = jsonencode({
    sshd = {
      enabled = true
      pwauth = true
    }
    rootpwcrypt = var.esx_pw
    esxishell = {
       enabled = true
    }
    kickstart = {
      firstboot_shell = "/bin/sh -C"
      firstboot_shell_cmd = <<EOT
sed -i '/^exit*/i /vmfs/volumes/datastore1/configpost.sh' /etc/rc.local.d/local.sh;
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
touch /vmfs/volumes/datastore1/configpost.sh;
chmod 755 /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-vswitch -p "VM Network" -v ${var.esx_mgmtvlan} vSwitch0' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip dns server add --server=${var.esx_dns}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip dns search add --domain=${var.esx_domain}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-advcfg -s ${var.esx_names[count.index].esxname}.${var.esx_domain} /Misc/hostname' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'echo "server ${var.esx_ntp}" >> /etc/ntp.conf' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'chkconfig ntpd on' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-vswitch -p "Management Network" -v ${var.esx_mgmtvlan} vSwitch0' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcli network ip interface ipv4 set -i vmk0 -I ${var.esx_ips[count.index].esxip} -N ${var.esx_subnet} -g ${var.esx_gateway} -t static' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-route ${var.esx_gateway}' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-vmknic -d "Private Network"' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'esxcfg-vswitch -D "Private Network" vSwitch0' >> /vmfs/volumes/datastore1/configpost.sh;
echo 'sed -i '/configpost.sh/d' /etc/rc.local.d/local.sh' >> /vmfs/volumes/datastore1/configpost.sh
EOT
      postinstall_shell = "/bin/sh -C"
      postinstall_shell_cmd = ""
    }
  })
}

resource "metal_port" "eth0" {
  count = length(var.esx_names)
  port_id = [for p in metal_device.esx[count.index].ports : p.id if p.name == "eth0"][0]
  vlan_ids = metal_vlan.vlans.*.id
  bonded = false
}

resource "metal_port" "eth1" {
  count = length(var.esx_names)
  port_id = [for p in metal_device.esx[count.index].ports : p.id if p.name == "eth1"][0]
  vlan_ids = metal_vlan.vlans.*.id
  bonded = false
}
