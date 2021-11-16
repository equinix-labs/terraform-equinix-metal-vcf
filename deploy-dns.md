# Deploy a DNS server with the default CloudBuilder configuration #

in this example we will create a VM running Ubuntu 20.04 with a cloudinit image that will deploy BIND9 and install a configuration that will match the CloudBuilder spreadsheet.  Remember that VCF needs forward and reverse lookups to function correctly so if you add a workload domain follow the layout in the zone files to add the names and IPs.  The files are **/var/lib/bind/172.16.11.rev** and **/var/lib/bind/sfo.rainpole.io.hosts**.  Reload BIND to apply the settings.

## Download and prepare the Ubuntu Cloud Image
```shell
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
cp focal-server-cloudimg-amd64.img /var/lib/libvirt/images/
qemu-img resize /var/lib/libvirt/images/focal-server-cloudimg-amd64.img 15G
```

## Create the cloudinit image with the zone files and network settings
You will paste the following in the shell of the edge instance. \
**Change the password for your VM in the chpasswd: section, look for ChangeYourPassword.**
```shell
cat > cloud_init.cfg << 'EOF'
#cloud-config
hostname: vcf-mgmt-dns
fqdn: vcf-mgmt-dns.rainpole.io
manage_etc_hosts: true
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    home: /home/ubuntu
    shell: /bin/bash
    lock_passwd: false

ssh_pwauth: true
disable_root: false
chpasswd:
  list: |
     ubuntu:ChangeYourPassword
  expire: false

package_update: true
packages:
  - bind9

growpart:
  mode: auto
  devices: ['/']

write_files:
  - path: /var/lib/cloud/scripts/per-once/sfo.rainpole.io.hosts
    permissions: "0644"
    content: |
      $ttl 3600
      sfo.rainpole.io.        IN      SOA     vcf-mgmt-dns.rainpole.io. root.localhost. (
                              1630330962
                              3600
                              600
                              1209600
                              3600 )
      sfo.rainpole.io.        IN      NS      vcf-mgmt-dns.rainpole.io.
      sfo-m01-vc01.sfo.rainpole.io.   IN      A       172.16.11.62
      sfo-m01-nsx01.sfo.rainpole.io.  IN      A       172.16.11.65
      sfo-m01-nsx01a.sfo.rainpole.io. IN      A       172.16.11.66
      sfo-m01-nsx01b.sfo.rainpole.io. IN      A       172.16.11.67
      sfo-m01-nsx01c.sfo.rainpole.io. IN      A       172.16.11.68
      sfo-m01-en01.sfo.rainpole.io.   IN      A       172.16.11.69
      sfo-m01-en02.sfo.rainpole.io.   IN      A       172.16.11.70
      sfo-vcf01.sfo.rainpole.io.      IN      A       172.16.11.59
      sfo01-m01-esx01.sfo.rainpole.io.        IN      A       172.16.11.101
      sfo01-m01-esx02.sfo.rainpole.io.        IN      A       172.16.11.102
      sfo01-m01-esx03.sfo.rainpole.io.        IN      A       172.16.11.103
      sfo01-m01-esx04.sfo.rainpole.io.        IN      A       172.16.11.104
  - path: /var/lib/cloud/scripts/per-once/172.16.11.rev
    permissions: "0644"
    content: |
      $ttl 3600
      11.16.172.in-addr.arpa. IN      SOA     vcf-mgmt-dns.rainpole.io. root.localhost. (
                              1630332362
                              3600
                              600
                              1209600
                              3600 )
      11.16.172.in-addr.arpa. IN      NS      vcf-mgmt-dns.rainpole.io.
      62.11.16.172.in-addr.arpa.      IN      PTR     sfo-m01-vc01.sfo.rainpole.io.
      65.11.16.172.in-addr.arpa.      IN      PTR     sfo-m01-nsx01.sfo.rainpole.io.
      66.11.16.172.in-addr.arpa.      IN      PTR     sfo-m01-nsx01a.sfo.rainpole.io.
      67.11.16.172.in-addr.arpa.      IN      PTR     sfo-m01-nsx01b.sfo.rainpole.io.
      68.11.16.172.in-addr.arpa.      IN      PTR     sfo-m01-nsx01c.sfo.rainpole.io.
      69.11.16.172.in-addr.arpa.      IN      PTR     sfo-m01-en01.sfo.rainpole.io.
      70.11.16.172.in-addr.arpa.      IN      PTR     sfo-m01-en02.sfo.rainpole.io.
      59.11.16.172.in-addr.arpa.      IN      PTR     sfo-vcf01.sfo.rainpole.io.
      101.11.16.172.in-addr.arpa.     IN      PTR     sfo01-m01-esx01.sfo.rainpole.io.
      102.11.16.172.in-addr.arpa.     IN      PTR     sfo01-m01-esx02.sfo.rainpole.io.
      103.11.16.172.in-addr.arpa.     IN      PTR     sfo01-m01-esx03.sfo.rainpole.io.
      104.11.16.172.in-addr.arpa.     IN      PTR     sfo01-m01-esx04.sfo.rainpole.io.
  - path: /var/lib/cloud/scripts/per-once/zfinished.sh
    permissions: "0755"
    content: |
      #!/bin/bash
      echo '' >> /etc/bind/named.conf.default-zones
      echo 'zone "sfo.rainpole.io" {' >> /etc/bind/named.conf.default-zones
      echo '              type master;' >> /etc/bind/named.conf.default-zones
      echo '              file "/var/lib/bind/sfo.rainpole.io.hosts";' >> /etc/bind/named.conf.default-zones
      echo '      };' >> /etc/bind/named.conf.default-zones
      echo '' >> /etc/bind/named.conf.default-zones
      echo '      zone "11.16.172.in-addr.arpa" {' >> /etc/bind/named.conf.default-zones
      echo '              type master;' >> /etc/bind/named.conf.default-zones
      echo '              file "/var/lib/bind/172.16.11.rev";' >> /etc/bind/named.conf.default-zones
      echo '      };' >> /etc/bind/named.conf.default-zones
      cp /var/lib/cloud/scripts/per-once/sfo.rainpole.io.hosts /var/lib/bind/
      cp /var/lib/cloud/scripts/per-once/172.16.11.rev /var/lib/bind/
      chmod root:bind /var/lib/bind/172.16.11.rev
      chmod root:bind /var/lib/bind/sfo.rainpole.io.hosts
      reboot
EOF

cat > network_config_static.cfg << 'EOF'
version: 2
ethernets:
  enp1s0:
     dhcp4: false
vlans:
    vlan1611:
        id: 1611
        link: enp1s0
        addresses: [ 172.16.11.4/24 ]
        gateway4: 172.16.11.253
        nameservers:
            addresses: [ 1.1.1.1,8.8.8.8 ]
EOF
cloud-localds -v --network-config=network_config_static.cfg /var/lib/libvirt/images/seed.img cloud_init.cfg
```

## launch the VM and set it to autostart ##
```shell
virt-install --name=vcf-mgmt-dns \
--import \
--vcpus=2 \
--memory=4096 \
--disk=/var/lib/libvirt/images/seed.img,device=cdrom \
--disk=/var/lib/libvirt/images/focal-server-cloudimg-amd64.img,device=disk,bus=virtio \
--network=network:bridge2,model=virtio \
--os-type=linux \
--os-variant=ubuntu20.04 \
--virt-type=kvm \
--graphics=none \
--console=pty,target_type=serial \
--noautoconsole

virsh autostart vcf-mgmt-dns
```
If you would like to access the console for the VM use the following.  To exit use CTRL+].
```shell
virsh console vcf-mgmt-dns
```
