## Manage the edge instance and launch the router and DNS server
SSH is enabled on the management interface from any source by default when using this script and will allow remote management of the Metal instance.<br/>

Now that the script has run you can launch any NFV or VM that you like.  Below is a Mikrotik example to help get you going quickly but any KVM compatible image will work like the Cisco 1000v or Juniper vSRX if you have the image and license.

#### Edge Router:  Use the CLI to deploy a Mikrotik RouterOS VM
The Mikrotik CHR will only run at 1Mbps per interface in unlicensed mode.  It is very easy to get a 60 day trial that will unlock the full speed of the interfaces.  the permanent license is affordable and easy to get.  Visit https://mikrotik.com/ for more info.

Before we begin, find the public IP that you will assign to this cloud router.  If you look at the output below you will see that a subnet with a /29 network is listed below bridge1.  You will be able to use the next IP in line for this VM and the IP listed as the gateway for the VM.

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
apt install unzip
wget https://download.mikrotik.com/routeros/6.49/chr-6.49.img.zip
unzip chr-6.49.img.zip
mv chr-6.49.img /var/lib/libvirt/images/
```

Now that the disk image is in place you can launch the VM 

```shell
virt-install --name=CloudRouter \
--import \
--vcpus=2 \
--memory=1024 \
--disk vol=default/chr-6.49.img,bus=sata \
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


Now you can connect to the instance and begin the configuration, To exit the console use **CTRL + ]**<br/>

```shell
root@edge-gateway:~# virsh console CloudRouter
Connected to domain CloudRouter
Escape character is ^]
MikroTik 6.48.3 (stable)
MikroTik Login: 
```
The username is admin and the router will prompt for a password.

Configure the first interface and set your passwords for the VPN by using the following commands
```shell
ip address add interface=ether1 address=100.200.20.9/29 #You found this on the bridge earlier
ip route add gateway=100.200.20.8 #this is the IP assigned to the bridge
ip dns set servers=1.1.1.1
#This will enable L2TP VPN on the Mikrotik with a user called "user1" and apply a shared secret and user password.
/interface l2tp-server server set enabled=yes use-ipsec=yes ipsec-secret=YourPassword #CHANGE THIS PASSWORD
/ppp secret add name=user1 password=YourPassword local-address=172.16.11.230 remote-address=172.16.11.231 #Change This password as well
```

### This is the IP you found using the who command earlier ###
ip firewall address-list add list=safe address=100.100.10.207

then copy the attached Mikrotik config file and paste it in the console to get your router configured with the default settings for VCF.
