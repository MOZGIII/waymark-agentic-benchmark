terraform {
  required_version = ">= 1.8"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.89"
    }
  }
}

provider "scaleway" {
  region = var.region
  zone   = var.zone
}
