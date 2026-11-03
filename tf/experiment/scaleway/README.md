# Scaleway

The API key in `.env` (`SCW_ACCESS_KEY`, `SCW_SECRET_KEY`, `SCW_DEFAULT_PROJECT_ID`) belongs to an IAM
application whose policy grants, at the scope of that project, these permission sets:

- `InstancesFullAccess` - servers, flexible IPs, security groups, private NICs, snapshots
- `BlockStorageFullAccess` - the servers' root volumes
- `VPCFullAccess` - the private network's VPC
- `PrivateNetworksFullAccess` - the private network and attaching servers to it; not covered by VPC access
- `IPAMFullAccess` - the reserved private addresses
- `SSHKeysFullAccess` - the host key, registered as a project SSH key

The same key serves `tf/snapshot/scaleway`, which needs nothing beyond the first two. Each set was found
by applying and reading the refusal, 2026-11-04; policy changes take up to a minute to apply.
