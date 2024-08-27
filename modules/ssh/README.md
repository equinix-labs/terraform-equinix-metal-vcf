# Equinix Metal Project SSH Key

This module creates a project SSH key for an Equinix Metal project.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | >= 1.30 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_equinix"></a> [equinix](#provider\_equinix) | >= 1.30 |
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [equinix_metal_project_ssh_key.ssh_pub_key](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_project_ssh_key) | resource |
| [local_file.project_private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_string.ssh_unique](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.ssh_key_pair](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The Equinix Metal project ID to create the SSH key in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_equinix_metal_ssh_key_id"></a> [equinix\_metal\_ssh\_key\_id](#output\_equinix\_metal\_ssh\_key\_id) | public key for bastion host |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | private key file for bastion host |
| <a name="output_ssh_private_key_contents"></a> [ssh\_private\_key\_contents](#output\_ssh\_private\_key\_contents) | private key contents for bastion host |
<!-- END_TF_DOCS -->
