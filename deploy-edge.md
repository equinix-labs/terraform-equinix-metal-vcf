# Manage the edge instance and launch the router

* In this example the management (MGMT) IP for the Instance is 100.100.100.10
* The elastic subnet forwarded to the VMs is 100.200.20.8/29
* the elastic subnet will be added as an alias to bridge1
* The first usable IP from the elastic block becomes the gateway for all VMs
* The KVM server is administered on the MGMT IP and only allows for SSH

![kvm-edge-instance](https://user-images.githubusercontent.com/74058939/141861429-42be576d-07b2-4bca-8f21-3a1783a1167c.png)

* The edge instance can run any virtual Router/Firewall NFV that you like.  Below are some options
    * Cisco 
    * Juniper
    * Miktorik
    * Fortinet
    * Palo Alto
    * VyOS 

* This tutorial will use a virtual Mikrotik to help get you going quickly

**The Mikrotik CHR will only run at 1Mbps per interface in unlicensed mode**.  It is very easy to get a 60 day trial that will unlock the full speed of the interfaces.  the permanent license is affordable and easy to get.  Visit https://mikrotik.com/ for more info.

SSH into the edge instance console and find the public IP that you will assign to this cloud router.  If you look at the output below you will see that a subnet with a /29 network is listed below bridge1.  You will be able to use the next IP in line for this VM and the IP listed as the gateway for the VM.

```shell
ip a
...
5: bridge1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc noqueue state UP group default qlen 1000
    link/ether b4:96:91:84:3d:f8 brd ff:ff:ff:ff:ff:ff
    inet 100.100.100.10/31 brd 255.255.255.255 scope global bridge1
       valid_lft forever preferred_lft forever
    inet 100.200.20.9/29 brd 100.200.20.14 scope global bridge1:0
       valid_lft forever preferred_lft forever
...
```

Download RouterOS RAW image from Mikrotik.  Unzip the image and move it to /var/lib/libvirt/images/

```shell
wget https://download.mikrotik.com/routeros/7.1/chr-7.1.img.zip
unzip chr-7.1.img.zip
mv chr-7.1.img /var/lib/libvirt/images/
```

Now that the disk image is in place you can launch the VM 

```shell
virt-install --name=CloudRouter \
--import \
--vcpus=2 \
--memory=1024 \
--disk vol=default/chr-7.1.img,bus=sata \
--network=network:bridge1,model=virtio \
--network=network:bridge2,model=virtio \
--os-type=generic \
--os-variant=generic \
--noautoconsole

virsh autostart CloudRouter
```


Before you begin configuring the Cloud Router find your own public IP so you can add it to the safe list for remote managment.  There are many ways to get your public IP but one of the easiest is to use the who command to see current connections on the instance.  This should return your public IP.

```shell
root@edge-gateway:~# who
root     pts/0        2021-01-01 00:00 (100.100.10.207)
```


Now you can open the Mikrotik console and begin the configuration, To exit the console use **CTRL + ]**<br/>

```shell
root@edge-gateway:~# virsh console CloudRouter
Connected to domain CloudRouter
Escape character is ^]
MikroTik 7.1 (stable)
MikroTik Login: 
```
The username is **admin** with no password.  The router will prompt for a password after you login the first time.

### The router is ready for the base config
Paste the following block to the router console and this will create a config that will match the default CloudBuilder spreadsheet.
```shell
/ip firewall filter
add action=accept chain=input comment="accept established connection packets" connection-state=established
add action=accept chain=input comment="accept related connection packets" connection-state=related
add action=drop chain=input comment="drop invalid packets" connection-state=invalid
add action=accept chain=input comment="Allow access to router from known network" src-address-list=safe
add action=drop chain=input comment="detect and drop port scan connections" protocol=tcp psd=21,3s,3,1
add action=tarpit chain=input comment="suppress DoS attack" connection-limit=3,32 protocol=tcp src-address-list=black_list
add action=add-src-to-address-list address-list=black_list address-list-timeout=1d chain=input comment="detect DoS attack" connection-limit=10,32 protocol=tcp
add action=jump chain=input comment="jump to chain ICMP" jump-target=ICMP protocol=icmp
add action=jump chain=input comment="jump to chain services" jump-target=services
add action=accept chain=input comment="Allow Broadcast Traffic" dst-address-type=broadcast
add action=log chain=input log-prefix=Filter:
add action=drop chain=input comment="drop everything else"
add action=accept chain=ICMP comment="0:0 and limit for 5pac/s" icmp-options=0:0-255 limit=5,5:packet protocol=icmp
add action=accept chain=ICMP comment="3:3 and limit for 5pac/s" icmp-options=3:3 limit=5,5:packet protocol=icmp
add action=accept chain=ICMP comment="3:4 and limit for 5pac/s" icmp-options=3:4 limit=5,5:packet protocol=icmp
add action=accept chain=ICMP comment="8:0 and limit for 5pac/s" icmp-options=8:0-255 limit=5,5:packet protocol=icmp
add action=accept chain=ICMP comment="11:0 and limit for 5pac/s" icmp-options=11:0-255 limit=5,5:packet protocol=icmp
add action=drop chain=ICMP comment="Drop everything else" protocol=icmp
add action=accept chain=services comment="accept localhost" dst-address=127.0.0.1 src-address=127.0.0.1
add action=accept chain=services comment="allow IPSec connections" dst-port=500 protocol=udp
add action=accept chain=services comment="allow IPSec" protocol=ipsec-esp
add action=accept chain=services comment="allow IPSec" protocol=ipsec-ah
add action=return chain=services
/ip firewall filter
add action=fasttrack-connection chain=forward comment=FastTrack connection-state=established,related
add action=accept chain=forward comment="Established, Related"  connection-state=established,related
add action=drop chain=forward comment="Drop invalid" connection-state=invalid log=yes log-prefix=invalid
add action=drop chain=forward comment="Drop incoming packets that are not NATted" connection-nat-state=!dstnat connection-state=new in-interface=ether1 log=yes log-prefix=!NAT
add action=drop chain=forward comment="Drop incoming from internet which is not public IP" in-interface=ether1 log=yes log-prefix=!public src-address-list=not_in_internet
/ip firewall address-list
add address=0.0.0.0/8 comment=RFC6890 list=not_in_internet
add address=172.16.0.0/12 comment=RFC6890 list=not_in_internet
add address=192.168.0.0/16 comment=RFC6890 list=not_in_internet
add address=10.0.0.0/8 comment=RFC6890 list=not_in_internet
add address=169.254.0.0/16 comment=RFC6890 list=not_in_internet
add address=127.0.0.0/8 comment=RFC6890 list=not_in_internet
add address=224.0.0.0/4 comment=Multicast list=not_in_internet
add address=198.18.0.0/15 comment=RFC6890 list=not_in_internet
add address=192.0.0.0/24 comment=RFC6890 list=not_in_internet
add address=192.0.2.0/24 comment=RFC6890 list=not_in_internet
add address=198.51.100.0/24 comment=RFC6890 list=not_in_internet
add address=203.0.113.0/24 comment=RFC6890 list=not_in_internet
add address=100.64.0.0/10 comment=RFC6890 list=not_in_internet
add address=240.0.0.0/4 comment=RFC6890 list=not_in_internet
add address=192.88.99.0/24 comment="6to4 relay Anycast [RFC 3068]" list=not_in_internet
/ipv6 firewall filter
add action=accept chain=input comment="Allow established connections" connection-state=established disabled=no
add action=accept chain=input comment="Allow related connections" connection-state=related disabled=no
add action=accept chain=input comment="Allow limited ICMP" disabled=no limit=50/5s,5 protocol=icmpv6
add action=drop chain=input comment="" disabled=no
add action=accept chain=forward comment="Allow any to internet" disabled=no out-interface=ether1
add action=accept chain=forward comment="Allow established connections" connection-state=established disabled=no
add action=accept chain=forward comment="Allow related connections" connection-state=related disabled=no
add action=drop chain=forward comment="" disabled=no
/interface set ether2 mtu=9000
/interface vlan add interface=ether2 vlan-id=1611 mtu=9000 name=1611-Management
/interface vlan add interface=ether2 vlan-id=1612 mtu=9000 name=1612-vMotion
/interface vlan add interface=ether2 vlan-id=1613 mtu=9000 name=1613-vSAN
/interface vlan add interface=ether2 vlan-id=1614 mtu=9000 name=1614-NSXtHostOverlay
/interface vlan add interface=ether2 vlan-id=2711 mtu=9000 name=2711-NSXtEdgeUplink1
/interface vlan add interface=ether2 vlan-id=2712 mtu=9000 name=2712-NSXtEdgeUplink2
/interface vlan add interface=ether2 vlan-id=2713 mtu=9000 name=2713-NSXtEdgeOverlay
/ip address add interface=1611-Management address=172.16.11.253/24
/ip address add interface=1612-vMotion address=172.16.12.253/24
/ip address add interface=1613-vSAN address=172.16.13.253/24
/ip address add interface=1614-NSXtHostOverlay address=172.16.14.253/24
/ip address add interface=2711-NSXtEdgeUplink1 address=172.27.11.253/24
/ip address add interface=2711-NSXtEdgeUplink1 address=172.27.11.1/24
/ip address add interface=2712-NSXtEdgeUplink2 address=172.27.12.253/24
/ip address add interface=2712-NSXtEdgeUplink2 address=172.27.12.1/24
/ip address add interface=2713-NSXtEdgeOverlay address=172.27.13.253/24
/ip firewall nat add chain=srcnat src-address=172.16.11.0/24 action=masquerade
/ip firewall nat add chain=srcnat src-address=172.27.11.0/24 action=masquerade
/ip firewall nat add chain=srcnat src-address=172.27.12.0/24 action=masquerade
/ip firewall nat add chain=srcnat src-address=172.27.13.0/24 action=masquerade
/ip firewall nat add chain=srcnat src-address=172.16.14.0/24 action=masquerade
/ip firewall address-list add list=safe address=172.16.0.0/12
/ip pool add name=NSXtHostOverlayPool ranges=172.16.14.2-172.16.14.200
/ip dhcp-server add name=NSXtHostOverlay interface=1614-NSXtHostOverlay address-pool=NSXtHostOverlayPool disabled=no
/ip dhcp-server network add address=172.16.14.0/24 gateway=172.16.14.253 dns-server=172.16.11.4
/routing bgp template add name=NSXtUplink1TORSIM as=65001 router-id=172.27.11.1
/routing bgp template add name=NSXtUplink2TORSIM as=65001 router-id=172.27.12.1
/routing bgp connection add name=EDGE1-1 templates=NSXtUplink1TORSIM remote.as=65003 remote.address=172.27.11.2 tcp-md5-key=VMw@re1! output.default-originate=always local.role=ebgp
/routing bgp connection add name=EDGE1-2 templates=NSXtUplink2TORSIM remote.as=65003 remote.address=172.27.12.2 tcp-md5-key=VMw@re1! output.default-originate=always local.role=ebgp
/routing bgp connection add name=EDGE2-1 templates=NSXtUplink1TORSIM remote.as=65003 remote.address=172.27.11.3 tcp-md5-key=VMw@re1! output.default-originate=always local.role=ebgp
/routing bgp connection add name=EDGE1-2 templates=NSXtUplink2TORSIM remote.as=65003 remote.address=172.27.12.3 tcp-md5-key=VMw@re1! output.default-originate=always local.role=ebgp
/system ntp client set enabled=yes mode=unicast servers=pool.ntp.org
/system ntp server set enabled=yes manycast=no broadcast=yes broadcast-addresses=172.16.11.255
```

### Now configure the first interface and set your passwords for the VPN by using the following commands ###

Make sure you change the lines below to fit your environment, this includes the IP, the gateway and the passwords.  This will enable L2TP VPN on the Mikrotik with a user called "user1".  The settings will apply a shared secret and user password, **please change the passwords!!**
```shell
/ip address add interface=ether1 address=100.200.20.9/29
/ip route add gateway=100.200.20.8
/ip dns set servers=1.1.1.1
/interface l2tp-server server set enabled=yes use-ipsec=yes ipsec-secret=**YourPassword**
/ppp secret add name=user1 password=**YourPassword** local-address=172.16.11.230 remote-address=172.16.11.231
```

### This is the IP you found using the who command earlier ###
```shell
/ip firewall address-list add list=safe address=100.100.10.207
```
