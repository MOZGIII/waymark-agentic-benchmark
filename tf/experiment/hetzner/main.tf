resource "hcloud_ssh_key" "host" {
  name       = "${var.run_id}-host"
  public_key = var.host_public_key
}

resource "hcloud_network" "experiment" {
  name     = var.run_id
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "experiment" {
  network_id   = hcloud_network.experiment.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = "10.0.1.0/24"
}

# Public interfaces accept only SSH; the private network is not filtered by
# cloud firewalls, so the workstation reaches production freely.
resource "hcloud_firewall" "experiment" {
  name = var.run_id

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "workstation" {
  name         = "${var.run_id}-workstation"
  server_type  = var.workstation_type
  image        = coalesce(var.workstation_snapshot_id, var.image)
  location     = var.location
  ssh_keys     = [hcloud_ssh_key.host.id]
  firewall_ids = [hcloud_firewall.experiment.id]
  labels       = { run = var.run_id, role = "workstation" }

  network {
    network_id = hcloud_network.experiment.id
    ip         = "10.0.1.2"
  }

  depends_on = [hcloud_network_subnet.experiment]
}

resource "hcloud_server" "production" {
  name         = "${var.run_id}-production"
  server_type  = var.production_type
  image        = coalesce(var.production_snapshot_id, var.image)
  location     = var.location
  ssh_keys     = [hcloud_ssh_key.host.id]
  firewall_ids = [hcloud_firewall.experiment.id]
  labels       = { run = var.run_id, role = "production" }

  network {
    network_id = hcloud_network.experiment.id
    ip         = "10.0.1.3"
  }

  depends_on = [hcloud_network_subnet.experiment]
}
