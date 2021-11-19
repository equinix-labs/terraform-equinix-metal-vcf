# VMWare Cloud Foundation on Equinix Metal

VMWare Cloud Foundation is a suite of products that provide an integrated stack of compute, storage and networking with centralized management and lifecycle controls.  VCF is divided into two major components, the management domain and workload domains.  The management domain is 4 ESX hosts with all the control plane virtual machines that will operate the infrastructure.  The workload domains are groups of ESX hosts that will run actual workloads like VDI, Tanzu or general-purpose virtual machines.  The VCF stack will allow you to easily add or remove hosts and build complex network solutions.  The VCF configuration system called CloudBuilder is an opinionated installer that will create the entire stack for you based on settings entered into a spreadsheet.  The VCF deployment can be a complex process but with this repo and instructions you should be able to deploy this whole stack in half a day.  VCF paired with Equinix Metal and the Equinix ecosystem will enable you to deploy and manage a private global infrastructure.  Scale out can now be an easy, low risk process giving you access to regions that are unfamiliar but critical to your business.

## What this project will do
This project will deploy the core infrastructure for a VCF management domain on Equinix Metal.  This will automatically configure 4 ESXi nodes to match the CloudBuilder default spreadsheet.   A Metal instance running KVM will be created to act as an edge host allowing you to quickly launch the routing and DNS VMs using the CLI. This particular layout is not a requirement as there are many ways to build edge and DNS servers. \
If you need to alter any of the settings just check the terraform.tfvars file.  You can add more "esx_names" and "esx_ips" to the ESX section to deploy more hosts at once or even add more hosts later for a workload domain.  Make sure you add the appropriate names and IPs to the DNS server before deploying a workload domain. 

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


---

Before you deploy make sure you generate a password for the script.  From any Linux host with whois installed you can quickly generate the password with the following command.
```shell
mkpasswd --method=SHA-512 --rounds=4096
```
The default script has the password set as ChangeYourPassword **(PLEASE DON'T FORGET TO CHANGE THIS)** \
Create a password with at least one digit, one symbol and more than 8 characters so CloudBuilder does not give a warning  \
Paste the result of the operation to the esx_pw field in the terraform.tfvars file incuded in this repo.

---

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
**If you see "Error: vlan assignment batch" at the end of the Terraform deploy \
just run "terraform apply" one more time and it will complete the install**

## Complete the edge first by following this doc

https://github.com/bjenkins-metal/vcf-metal/blob/main/deploy-edge.md

## Complete the DNS server by following this doc

https://github.com/bjenkins-metal/vcf-metal/blob/main/deploy-dns.md

## Time to run CloudBuilder

You will need to obtain the CloudBuilder ISO from the my.vmware portal and get the licenses for ESXi, vSAN, vCenter and NSX-T to add to the spreadsheet.

The fastest way to get started is to launch a temporary Windows jump host in your Metal project.  This will give you a quick way to download the large CloudBuilder ISO (18GB) and install it on the first ESXi host to begin the process.  You can also use the VPN and do this from your local computer and just wait for the 18GB to upload to the ESXi host if you do not want to run a jump host.  FYI You will not be able to use the local datastore since this is an OVA install so just be patient when doing this part if you do it remotely.

## Configure the Windows jump host using this doc
https://github.com/bjenkins-metal/vcf-metal/blob/main/jumphost-tips.md

## Access the first host and install CloudBuilder

Now you can use the Windows host to access the infrastructure and deploy CloudBuilder.  From the Windows host use your favorite browser to access https://172.16.11.101 and login as root with the password you assigned to the script in the terraform.tfvars file.

Once logged in go to "Virtual Machines" on the left and click "Create/Register VM" \
Choose the option "Deploy a virtual machine from an OVF or OVA file \
name your VM cloudbuilder \
Click the blue box to select the OVA for cloudbuilder that you downloaded from my.vmware \
Click next all the way to Additional Settings and expand "Application"
Fill in every box \
Enter a password that will be assigned to the CloudBuilder instance admin and root user \
The hostname can be cloudbuilder \
Network 1 IP address is 172.16.11.10 and 254.255.255.0 for the subnet mask with 172.16.11.253 as the gateway \
The DNS server is 172.16.11.4 \
The DNS Domain Name and Search path are both sfo.rainpole.io \
Finally the NTP server is 172.16.11.253
Click next and finish

## Before running CloudBuilder check your drive layout

One of the most common blockers for CloudBuilder is the host drive setup.  You should check the individual hosts for the drive layout.  CloudBuilder does not like to see 3 drive types and a few of the M3.large instances may have "bonus drives" in them attached to a HBA330-Mini.

Here is an example of what you may see.  The top image is what you want, the bottom is what you might see.

![toubleshoot-disk](https://user-images.githubusercontent.com/74058939/142466304-bbae8aa0-dea9-4590-80cb-76a1eb03d17a.png)

If you find that you have an extra drive listed, follow this doc to disable the drive so the installer will work.

https://github.com/bjenkins-metal/vcf-metal/blob/main/m3.large-drives.md

## Run cloudBuilder and create your VCF stack
from the jump host or via VPN open a browser and go to https://172.16.11.10 \
Login with admin and the password you assigned in the last step. \
You will need to edit a spreadsheet in this step so make sure you have an office app that can open and save Excel files.

Follow the prompts once you log in and get to the point where you download the spreadsheet \
Open the spreadsheet and find the "Management Workloads" tab and paste your license keys. You do not need the SDDC Manager Appliance key \
Now find the "Users and Groups" tab.  Enter the password you assigned to the ESXi hosts in the first row and then create passwords for the rest of the services.  If the ESXi password in the spreadsheet does not match the script password that you generated the install will fail. \
Now save the worksheet and upload it to CloudBuilder and let the validation run.  It will not take long and you will be alerted to any issues that would prevent the install from running.  \
**You will notice that the ESXi version will give a warning, that is totally normal and you can just acknowledge the alert and continue.** \
When you click Nect after a successful validation the stack will begin to build itself.  Be patient, this will take some time.  Once the installer is complete you will be able to log in to the various components of the stack.  \

Here are the useful IPs and names \
vCenter: 172.16.11.62 (sfo-m01-vc01) \
NSX-T Manager: 172.16.11.65 (sfo-m01-nsx01) \
SDDC Manager: 172.16.11.59 (sfo-vcf01)

You should have a fully functional management domain.  Time to dig into the VCF docs! \
https://docs.vmware.com/en/VMware-Cloud-Foundation/index.html





