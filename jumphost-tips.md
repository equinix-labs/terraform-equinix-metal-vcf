# Tips for configuring the Windows jump host on Equinix Metal

If you have never added a VLAN to a Windows server it could be a little confusing so I will include the steps here to simplify the process.

* In the Metal portal launch your Windows host on a c3.small instance
* When the install is complete click the instance and go to the network tab in the Metal portal
  * Switch the network mode to **Hybrid Bonded** and pick VLAN 1611
* RDP into the Windows server
* From server manager click local server and then NIC teaming
* From the teaming interface find the bottom right window called Adapters and Interfaces
  * Click the "Team Interfaces" tab in the Adapters and Interfaces window and you will see the default bond
  * Click on tasks and then Add Interface
    * Sometimes you need to click away from the window and back in for the Add Interface option to appear
  * Enter 1611 in the Specific VLAN box and click OK
  * You will now have a new adapter to configure called "bond_bond0 - VLAN 1611"
* Edit this new adapter the same way you would any adapter and assign an IPv4 address with no gateway.  
  * ADDRESS: 172.16.11.9
  * Subnet Mask: 255.255.255.0
  * DNS server 172.16.11.4

![windows-vlan](https://user-images.githubusercontent.com/74058939/142064791-7bd305f2-8034-4fe7-97fc-367e770041af.png)
