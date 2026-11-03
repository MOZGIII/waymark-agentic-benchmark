output "workstation_snapshot_id" {
  description = "Provider id of the workstation snapshot."
  value       = scaleway_block_snapshot.workstation.id
}

output "production_snapshot_id" {
  description = "Provider id of the production snapshot."
  value       = scaleway_block_snapshot.production.id
}
