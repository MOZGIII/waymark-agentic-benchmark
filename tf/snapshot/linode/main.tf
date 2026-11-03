# Linode images are taken from one disk, so each machine's root disk is looked
# up through the instances data source, excluding the swap disk the stock
# image creates.

data "linode_instances" "workstation" {
  filter {
    name   = "id"
    values = [var.workstation_id]
  }
}

data "linode_instances" "production" {
  filter {
    name   = "id"
    values = [var.production_id]
  }
}

locals {
  workstation_disk = [for d in data.linode_instances.workstation.instances[0].disk : d.id if d.filesystem != "swap"][0]
  production_disk  = [for d in data.linode_instances.production.instances[0].disk : d.id if d.filesystem != "swap"][0]
}

resource "linode_image" "workstation" {
  label     = "${var.run_id}-workstation"
  linode_id = tonumber(var.workstation_id)
  disk_id   = local.workstation_disk
  tags      = [var.run_id]
}

resource "linode_image" "production" {
  label     = "${var.run_id}-production"
  linode_id = tonumber(var.production_id)
  disk_id   = local.production_disk
  tags      = [var.run_id]
}
