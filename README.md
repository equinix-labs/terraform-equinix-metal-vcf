# VMWare Cloud Foundation on Equinix Metal

VMWare Cloud Foundation is a suite of products that provide an integrated stack of compute, storage and networking with centralized management and lifecycle controls.  VCF is divided into two major components, the management domain and workload domains.  The management domain is 4 ESX hosts with all the control plane virtual machines that will operate the infrastructure.  The workload domains are groups of ESX hosts that will run actual workloads like VDI, Tanzu or general-purpose virtual machines.  The VCF stack will allow you to easily add or remove hosts and build complex network solutions.  The VCF configuration system called CloudBuilder is an opinionated installer what will create the entire stack for you in about 3 hours.  The VCF deployment can be a complex process but with this repo and instructions you should be able to deploy this whole stack in half a day.  VCF paired with Equinix Metal and the Equinix ecosystem will enable you to deploy and manage a private global infrastructure.  Scale out can now be an easy, low risk excercise in regions that are unfamiliar but critical to your business.

## What this project will do
This project will deploy the core infrastructure for a VMWare VCF management domain on Equinix Metal.  This will automatically configure 4 ESXi nodes to match the CloudBuilder spreadsheet and deploy an instance to act as the edge router and DNS server for the project.  If you need to alter any of the settings just check the terraform.tfvars file.  You can add more "esx_names" and "esx_ips" to the ESX section to deploy more hosts at once or even add more hosts later for a workload domain.  Make sure you add the appropriate names and IPs to the DNS server before deploying a workload domain.

## You will need to complete the following tasks
Deploy the core infrastrucure using the Terraform script in this repo \
Configure an edge router, in this case Miktorik but any NFV will work \
Configure a VM to act as the DNS server \
prepare and launch CloudBuilder to configure the VCF management domain

You will need the following to use this project
1. An Equinix Metal account. \
 If you need an Equinix Metal account please visit https://console.equinix.com. \
 Find the Equinix Metal documentation at https://metal.equinix.com/developers/docs/
2. You will need Terraform https://www.terraform.io/ and this repo
3. You will need a my.vmware account to obtain the CloudBuilder ISO and licenses.  This project assumes VCF 4.1 since it has the most opinionated install process and is great for learning how it all works.
4. **Some patience** \
 VCF is a complex and amazing bundle of all the best products VMWare has to offer.  There will be plenty of opportunity to mis-type or miss a step so if you get an error just go back and look through the steps and check your work.  You will have the option to "try again" at various times through the process.

## This project is experimental and designed to give you direction on ways to get VCF up and running.  If you do anything for production please spend some time thinking through the security implications and make sure you alter all the settings to fit your environment.  There is no support for this project.  The most important thing to remember... have fun!

## Overview

![VMWare-VCF-Layout](https://user-images.githubusercontent.com/74058939/142038048-d46f564d-9e5e-473b-873b-12d7b867210f.png)

This project will use a Metal instance running KVM for the edge host. This will allow you to quickly launch the routing and DNS VMs quickly using the CLI.  This particular layout is not a requirement and there are many ways to build ingress/egress at Equinix.  You could build a 100% VMware layout or connect back to existing infrastructure.

Deploy the KVM edge instance and ESXi nodes.  The terraform.tfvars file is aligned with the default CloudBuilder spreadsheet but can be altered to meet your specific requirements if needed.
```shell
terraform init
terraform plan
terraform apply
```
When you want to remove the project simply run the following command.
```shell
terraform destroy
```
## Complete the edge first by following this doc

https://github.com/bjenkins-metal/vcf-metal/blob/main/deploy-edge.md

## Complete the DNS server by following this doc

https://github.com/bjenkins-metal/vcf-metal/blob/main/deploy-dns.md

## Time to run CloudBuilder

You will need to obtain the CloudBuilder ISO from the my.vmware portal and get the licenses for ESXi, vSAN, vCenter and NSX-T to add to the spreadsheet.

The fastest way to get started is to launch a temporary Windows jump host in your Metal project.  This will give you a quick way to download the large CloudBuilder ISO (18GB) and install it on the first ESXi host to begin the process.  You can use the VPN and do this from your local computer and just wait for the 18GB to upload to the ESXi host.  You will not be able to use the local datastore since this is an OVA install so just be patient when doing this part if you do it remotely.

If you have never added a VLAN to a Windows server it could be a little confusing so I will include it here to simplify the process.
First in the Metal portal launch your Windows host on a c3.small instance.  When it completes the install go to the network tab in the Metal portal and switch the network mode to **Hybrid Bonded** and pick VLAN 1611 (management).  Now RDP into the Windows server and from server manager click local server and then NIC teaming.  Then the teaming interface pops up look at the bottom right window called Adapters and Interfaces.  Click the Team Interfaces tab in that little window and you will see the default bond.  Click on tasks and then Add Interface.  Enter 1611 in the Specific VLAN box and click OK.  You will now have a new adapter to configure called 
"bond_bond0 - VLAN 1611".  Edit this new adapter the same way you would any adapter and assign an IPv4 address with no gateway.  I use 172.16.11.9 and 255.255.255.0.

![windows-vlan](https://user-images.githubusercontent.com/74058939/142064791-7bd305f2-8034-4fe7-97fc-367e770041af.png)
