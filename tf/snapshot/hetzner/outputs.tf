output "workstation_snapshot_id" {
  description = "Provider id of the workstation snapshot."
  value       = hcloud_snapshot.workstation.id
}

output "production_snapshot_id" {
  description = "Provider id of the production snapshot."
  value       = hcloud_snapshot.production.id
}
