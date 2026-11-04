# Every tf/experiment/<provider> root takes these variables and emits the
# outputs in outputs.tf. Per-run values arrive from bin/experiment-create via
# -var-file; the rest come from a git-ignored *.auto.tfvars in this directory.

variable "run_id" {
  description = "Run id; names every resource so a run is identifiable in the provider console."
  type        = string
}

variable "host_public_key" {
  description = "SSH public key of the experiments host, installed on both machines."
  type        = string
}

variable "region" {
  description = "Scaleway region holding the private network."
  type        = string
  default     = "nl-ams"
}

variable "zone" {
  description = "Scaleway zone for both machines; must be in the region."
  type        = string
  default     = "nl-ams-1"
}

variable "image" {
  description = "Marketplace image label; the stock Debian, never a custom snapshot."
  type        = string
  default     = "debian_trixie"
}

variable "workstation_type" {
  description = "Instance type of the workstation (x86_64, about 4 cores and 8 GB)."
  type        = string
  default     = "DEV1-L"
}

variable "production_type" {
  description = "Instance type of the production machine, the same class as the workstation."
  type        = string
  default     = "DEV1-L"
}

variable "root_volume_size_gb" {
  description = "Root volume size of each machine; the image's 10 GB otherwise. Hetzner and Linode size it by type."
  type        = number
  default     = 40
}

variable "workstation_snapshot_id" {
  description = "Boot the workstation from this snapshot of an earlier run; null boots the image."
  type        = string
  default     = null
}

variable "production_snapshot_id" {
  description = "Boot the production machine from this snapshot of an earlier run; null boots the image."
  type        = string
  default     = null
}
