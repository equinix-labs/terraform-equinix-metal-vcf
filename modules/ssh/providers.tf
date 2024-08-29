terraform {
  required_version = ">= 1.0"
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = ">= 1.30"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }
  }
}
