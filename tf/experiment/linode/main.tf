# The private network is a VLAN with static addresses; VLAN traffic is not
# filtered by cloud firewalls, so the workstation reaches production freely.

resource "linode_instance" "workstation" {
  label           = "${var.run_id}-workstation"
  region          = var.region
  type            = var.workstation_type
  image           = coalesce(var.workstation_snapshot_id, var.image)
  authorized_keys = [trimspace(var.host_public_key)]
  tags            = [var.run_id]

  interface {
    purpose = "public"
  }

  interface {
    purpose      = "vlan"
    label        = var.run_id
    ipam_address = "10.0.1.2/24"
  }
}

resource "linode_instance" "production" {
  label           = "${var.run_id}-production"
  region          = var.region
  type            = var.production_type
  image           = coalesce(var.production_snapshot_id, var.image)
  authorized_keys = [trimspace(var.host_public_key)]
  tags            = [var.run_id]

  interface {
    purpose = "public"
  }

  interface {
    purpose      = "vlan"
    label        = var.run_id
    ipam_address = "10.0.1.3/24"
  }
}

# Public interfaces accept only SSH and ping.
resource "linode_firewall" "experiment" {
  label           = var.run_id
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"
  linodes         = [linode_instance.workstation.id, linode_instance.production.id]

  inbound {
    label    = "ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound {
    label    = "ping"
    action   = "ACCEPT"
    protocol = "ICMP"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }
}

# The instance's own ip_address attribute is deprecated; the networking data
# source is the supported way to read the public address.
data "linode_instance_networking" "workstation" {
  linode_id = linode_instance.workstation.id
}

data "linode_instance_networking" "production" {
  linode_id = linode_instance.production.id
}
