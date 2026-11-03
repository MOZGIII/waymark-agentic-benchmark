resource "hcloud_snapshot" "workstation" {
  server_id   = tonumber(var.workstation_id)
  description = "${var.run_id}-workstation"
  labels      = { run = var.run_id, role = "workstation" }
}

resource "hcloud_snapshot" "production" {
  server_id   = tonumber(var.production_id)
  description = "${var.run_id}-production"
  labels      = { run = var.run_id, role = "production" }
}
