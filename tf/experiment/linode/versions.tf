terraform {
  required_version = ">= 1.8"
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 4.0"
    }
  }
}

# Token from LINODE_TOKEN, exported by lib/common.sh from .env.
provider "linode" {}
