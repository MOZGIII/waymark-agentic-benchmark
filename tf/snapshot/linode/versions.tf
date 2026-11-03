terraform {
  required_version = ">= 1.8"
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 4.0"
    }
  }
}

provider "linode" {}
