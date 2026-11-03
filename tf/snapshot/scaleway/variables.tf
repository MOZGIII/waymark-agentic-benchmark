# Every tf/snapshot/<provider> root takes these variables and emits the
# outputs in outputs.tf. The ids are the ones tf/experiment recorded in the
# run's manifest; bin/experiment-snapshot passes them via -var-file.

variable "run_id" {
  description = "Run id; names the snapshots."
  type        = string
}

variable "workstation_id" {
  description = "Provider id of the workstation."
  type        = string
}

variable "production_id" {
  description = "Provider id of the production machine."
  type        = string
}

variable "region" {
  description = "Scaleway region of the machines; must match tf/experiment/scaleway."
  type        = string
  default     = "nl-ams"
}

variable "zone" {
  description = "Scaleway zone of the machines; must match tf/experiment/scaleway."
  type        = string
  default     = "nl-ams-1"
}
