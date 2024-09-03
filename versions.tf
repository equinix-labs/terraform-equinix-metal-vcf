terraform {
  required_version = ">= 1.5"

  provider_meta "equinix" {
    module_name = "terraform-equinix-metal-vcf"
  }

  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = ">= 1.35"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }

  }
}

# Configure the Equinix Metal credentials.
provider "equinix" {
  client_id     = var.equinix_client_id
  client_secret = var.equinix_client_secret
  auth_token    = var.metal_auth_token
}
