terraform {
  required_version = ">= 1.5"
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = ">= 1.35.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3"
    }
  }
}
