terraform {
  required_version = ">= 1.8"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.70"
    }
  }
}

# Token from HCLOUD_TOKEN, exported by lib/common.sh from .env.
provider "hcloud" {}
