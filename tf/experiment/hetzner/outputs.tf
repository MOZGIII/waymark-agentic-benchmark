output "workstation" {
  description = "Provider id and addresses of the workstation."
  value = {
    id         = hcloud_server.workstation.id
    public_ip  = hcloud_server.workstation.ipv4_address
    private_ip = one(hcloud_server.workstation.network).ip
  }
}

output "production" {
  description = "Provider id and addresses of the production machine."
  value = {
    id         = hcloud_server.production.id
    public_ip  = hcloud_server.production.ipv4_address
    private_ip = one(hcloud_server.production.network).ip
  }
}

output "ssh_user" {
  description = "User the host's key is installed for."
  value       = "root"
}
