output "workstation" {
  description = "Provider id and addresses of the workstation."
  value = {
    id         = linode_instance.workstation.id
    public_ip  = data.linode_instance_networking.workstation.ipv4[0].public[0].address
    private_ip = "10.0.1.2"
  }
}

output "production" {
  description = "Provider id and addresses of the production machine."
  value = {
    id         = linode_instance.production.id
    public_ip  = data.linode_instance_networking.production.ipv4[0].public[0].address
    private_ip = "10.0.1.3"
  }
}

output "ssh_user" {
  description = "User the host's key is installed for."
  value       = "root"
}
