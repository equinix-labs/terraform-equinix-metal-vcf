locals {
  ssh_key_name = format("ssh-key-%s", random_string.ssh_unique.result)
  ssh_key_file = abspath("${path.root}/${local.ssh_key_name}")
}

resource "random_string" "ssh_unique" {
  length  = 5
  special = false
  upper   = false
}

resource "tls_private_key" "ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "equinix_metal_project_ssh_key" "ssh_pub_key" {
  name       = local.ssh_key_name
  public_key = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  project_id = var.project_id
}

resource "local_file" "project_private_key_pem" {
  content         = chomp(tls_private_key.ssh_key_pair.private_key_pem)
  filename        = local.ssh_key_file
  file_permission = "0600"
}
