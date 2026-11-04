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

variable "location" {
  description = "Hetzner location for both machines."
  type        = string
  default     = "nbg1"
}

variable "network_zone" {
  description = "Hetzner network zone containing the location."
  type        = string
  default     = "eu-central"
}

variable "image" {
  description = "Provider image name; the stock Debian, never a custom snapshot."
  type        = string
  default     = "debian-13"
}

variable "workstation_type" {
  description = "Server type of the workstation (x86_64, about 4 cores and 8 GB)."
  type        = string
  default     = "cpx31"
}

variable "production_type" {
  description = "Server type of the production machine, the same class as the workstation."
  type        = string
  default     = "cpx31"
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
