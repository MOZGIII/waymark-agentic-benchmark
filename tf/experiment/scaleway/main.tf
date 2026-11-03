# SSH keys are installed on new instances from the project's IAM keys, so the
# host key is registered there under the run id.
resource "scaleway_iam_ssh_key" "host" {
  name       = "${var.run_id}-host"
  public_key = var.host_public_key
}

resource "scaleway_vpc_private_network" "experiment" {
  name = var.run_id

  ipv4_subnet {
    subnet = "10.0.1.0/24"
  }
}

# Static private addresses are reserved in IPAM and bound through explicit
# private NICs; the inline private_network block cannot pin an address.
resource "scaleway_ipam_ip" "workstation" {
  address = "10.0.1.2"
  source {
    private_network_id = scaleway_vpc_private_network.experiment.id
  }
}

resource "scaleway_ipam_ip" "production" {
  address = "10.0.1.3"
  source {
    private_network_id = scaleway_vpc_private_network.experiment.id
  }
}

# Public interfaces accept only SSH and ping; private network traffic is not
# subject to security groups.
resource "scaleway_instance_security_group" "experiment" {
  name                    = var.run_id
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action   = "accept"
    protocol = "TCP"
    port     = 22
  }

  inbound_rule {
    action   = "accept"
    protocol = "ICMP"
  }
}

resource "scaleway_instance_ip" "workstation" {}
resource "scaleway_instance_ip" "production" {}

resource "scaleway_instance_server" "workstation" {
  name              = "${var.run_id}-workstation"
  type              = var.workstation_type
  image             = var.image
  ip_id             = scaleway_instance_ip.workstation.id
  security_group_id = scaleway_instance_security_group.experiment.id
  tags              = [var.run_id, "workstation"]

  # Block storage, sized explicitly; tf/snapshot/scaleway snapshots it as such.
  root_volume {
    volume_type = "sbs_volume"
    size_in_gb  = var.root_volume_size_gb
  }

  depends_on = [scaleway_iam_ssh_key.host]
}

resource "scaleway_instance_server" "production" {
  name              = "${var.run_id}-production"
  type              = var.production_type
  image             = var.image
  ip_id             = scaleway_instance_ip.production.id
  security_group_id = scaleway_instance_security_group.experiment.id
  tags              = [var.run_id, "production"]

  # Block storage, sized explicitly; tf/snapshot/scaleway snapshots it as such.
  root_volume {
    volume_type = "sbs_volume"
    size_in_gb  = var.root_volume_size_gb
  }

  depends_on = [scaleway_iam_ssh_key.host]
}

resource "scaleway_instance_private_nic" "workstation" {
  server_id          = scaleway_instance_server.workstation.id
  private_network_id = scaleway_vpc_private_network.experiment.id
  ipam_ip_ids        = [scaleway_ipam_ip.workstation.id]
}

resource "scaleway_instance_private_nic" "production" {
  server_id          = scaleway_instance_server.production.id
  private_network_id = scaleway_vpc_private_network.experiment.id
  ipam_ip_ids        = [scaleway_ipam_ip.production.id]
}
