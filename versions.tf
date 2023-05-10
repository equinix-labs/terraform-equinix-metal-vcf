terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "~> 1.14"
    }
  }

 required_version = ">= 0.13"
 provider_meta "equinix" {
    module_name = "equinix-metal-vcf"
  }
}
