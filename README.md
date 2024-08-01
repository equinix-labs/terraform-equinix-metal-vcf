# tfm-eqix-metal-vcf
Module based Terraform project for deploying VMware VCF resources on Equinix Metal

## Custom root password

### Generating custom root password
To generate a password hash of your desired ESXi root password run the 'mkpasswd' command on a Linux system with the 'whois' package installed as follows

```shell
mkpasswd --method=SHA-512
```
You'll be prompted to enter the desired password sting you wish to hash, then press enter. 

![Alt text](assets/9-mkpasswd_example.png?raw=true "mkpasswd Example")

The output will be the string you need to use in the rootpwcrypt entry near the end of the esxi-customdata-example.json file

![Alt text](assets/10-mkpasswd_in_json.png?raw=true "mkpasswd Example in rootpwcrypt")