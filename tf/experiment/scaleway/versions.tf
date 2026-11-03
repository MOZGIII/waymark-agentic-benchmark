terraform {
  required_version = ">= 1.8"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.89"
    }
  }
}

# Credentials from SCW_ACCESS_KEY, SCW_SECRET_KEY and SCW_DEFAULT_PROJECT_ID,
# exported by lib/common.sh from .env.
provider "scaleway" {
  region = var.region
  zone   = var.zone
}
