# VMWare VCF on Equinix Metal

VMWare Cloud Foundation is a suite of products that provides an integrated stack of compute, storage and networking with centralized management and lifecycle controls.  VCF is broken into two major components, the management domain and workload domains.  The management domain is 4 ESX hosts with all the control plane virtual machines that will operate the infrastructure.  The workload domains are isolated groups of ESX hosts that will run actual workloads like VDI, Tanzu or general-purpose virtual machines.  The VCF stack will allow you to easily add and remove hosts and build complex networking solutions.  The installer is called CloudBuilder and is an opinionated installer what will create the entire stack for you in about 3 hours.  This is a complex process but with this repo and instructions you should be able to deploy this whole stack in half a day and see how it works.  VCF paired with Equinix Metal and the Equinix ecosystem will allow you to deploy and manage a global infrastructure in a private environment quickly and easily.  The best part is scale out.  You can do easy, low risk deployments in regions that are unfamiliar but critical to your business.

## What this project will do
This project will deploy the core infrastructure for a VMWare VCF management domain on Equinix Metal.  This will automatically configure 4 ESXi nodes to match the CloudBuilder spreadsheet and deploy an instance to act as the edge router and DNS server for the project.  If you need to alter any of the settings just check the terraform.tfvars file.  You can add more "esx_names" and "esx_ips" to the ESX section to deploy more hosts at once or even add more hosts later for a workload domain.  Make sure you add the appropriate names and IPs to the DNS server before deploying a workload domain.

## You will need to complete the following tasks \
Deploy the core infrastrucure using the Terraform script in this repo \
Configure an edge router, in this case Miktorik but any NFV will work. \
Configure a VM to act as the DNS server \
prepare and launch CloudBuilder to configure the VCF management domain.

You will need the following to use this project
1. An Equinix Metal account. \
 If you need an Equinix Metal account please visit https://console.equinix.com. \
 Find the Equinix Metal documentation at https://metal.equinix.com/developers/docs/
2. You will need Terraform https://www.terraform.io/ and this repo
3. You will need a my.vmware account to obtain the CloudBuilder ISO and licenses.  This project assumes VCF 4.1 since it has the most opinionated install process and is great for learning how it all works.
4. **Some patience** \
 VCF is a complex and amazing bundle of all the best products VMWare has to offer.  There will be plenty of opportunity to mis-type or miss a step so if you get an error just go back and look through the steps and check your work.  You will have the option to "try again" at various times through the process.

## This project is experimental and designed to give you direction on ways to get VCF up and running.  If you do anything for production please spend some time thinking through the security implications and make sure you alter all the settings to fit your environment.  There is no support for these scripts or a deployment using these scripts.

## Overview

![VMWare-VCF-Layout](https://user-images.githubusercontent.com/74058939/141851594-9ac56b09-4880-4bc5-881e-87ce11cc6296.png)

This example project will use KVM for the edge instance so you can launch any NFV you like and add a DNS server quickly using the CLI.  This particular edge is not a requirement and there are many ways to build ingress/egress at Equinix.

Deploy the KVM edge instance and ESXi nodes
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
