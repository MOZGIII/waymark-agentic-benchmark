output "workstation" {
  description = "Provider id and addresses of the workstation."
  value = {
    id         = scaleway_instance_server.workstation.id
    public_ip  = scaleway_instance_ip.workstation.address
    private_ip = scaleway_ipam_ip.workstation.address
  }
}

output "production" {
  description = "Provider id and addresses of the production machine."
  value = {
    id         = scaleway_instance_server.production.id
    public_ip  = scaleway_instance_ip.production.address
    private_ip = scaleway_ipam_ip.production.address
  }
}

output "ssh_user" {
  description = "User the host's key is installed for."
  value       = "root"
}
