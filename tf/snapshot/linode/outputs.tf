output "workstation_snapshot_id" {
  description = "Provider id of the workstation image."
  value       = linode_image.workstation.id
}

output "production_snapshot_id" {
  description = "Provider id of the production image."
  value       = linode_image.production.id
}
