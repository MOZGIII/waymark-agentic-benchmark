# Scaleway root volumes are block storage volumes, snapshotted through the
# block storage API; each machine's root volume is looked up first.

data "scaleway_instance_server" "workstation" {
  server_id = var.workstation_id
}

data "scaleway_instance_server" "production" {
  server_id = var.production_id
}

resource "scaleway_block_snapshot" "workstation" {
  name      = "${var.run_id}-workstation"
  volume_id = data.scaleway_instance_server.workstation.root_volume[0].volume_id
  tags      = [var.run_id, "workstation"]
}

resource "scaleway_block_snapshot" "production" {
  name      = "${var.run_id}-production"
  volume_id = data.scaleway_instance_server.production.root_volume[0].volume_id
  tags      = [var.run_id, "production"]
}
