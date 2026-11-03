# Environment

Nothing runs on a developer's own machine. Three roles, all cloud VMs.

## Experiments host

One long-lived small VM, arranged by hand. It holds a checkout of this repository, the cloud
credentials, an SSH key and the tooling (OpenTofu, Ansible, ssh, jq). It drives every experiment and keeps
the run directories until results are pushed elsewhere. It never runs an agent. It is deliberately
stateless beyond those directories so it could later be replaced by something lighter than a VM.

## Experiment targets

Each experiment gets two fresh VMs, created right before the run and destroyed after it:

- **workstation**: simulates the developer's machine. The agent runs here with Docker, the pinned agent
  CLIs and an SSH key to the production machine. Its shell tools therefore act only on this VM.
- **production**: simulates the deployment server. Stock Debian with Docker preinstalled and nothing
  else. Whatever the framework needs there, the agent installs over SSH.

Both are the same CPU architecture (x86_64) so image builds on the workstation run unchanged on
production, and the same size (about 4 cores and 8 GB) so no framework's server component is starved.
They share a private network; only outbound internet and SSH from the host are otherwise reachable.

The prompt tells the agent this shape: no CI, no container registry, build images locally and push them
directly to production. Docker on production is preinstalled because installing it is identical work for
every framework and would only add noise.

## No golden image

Targets start from the provider's stock Debian image and are prepared per run by Ansible playbooks with
every version pinned. This avoids building, storing and versioning images. Reproducibility comes from
recording the provider's image identifier, the playbook hash and a package list dumped after preparation.
Packer was considered and rejected: it has no open fork, and its single non-interactive build is the
wrong shape for a flow that has an agent session in the middle.

## Providers

Infrastructure is driven by OpenTofu. Each provider is a module behind one fixed interface (inputs: run
id, sizes, architecture, region, keys; outputs: addresses and ids of both VMs), selected by a variable.
Hetzner and Linode are both supported, and the provider is a recorded run parameter.
