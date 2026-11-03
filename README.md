# waymark-agentic-benchmark

Machinery for measuring how coding agents build and deploy one sample application with waymark versus
competing durable-workflow frameworks: same frozen prompt, fresh cloud VMs per run, tokens and time
recorded, results scored separately. The reasoning behind the setup is in [docs/design](docs/design).

This repository is for the machinery only. The code the agents produce and the reports live elsewhere.

## Operating an experiment

Run from a checkout on the experiments host with `.env` filled in from `.env.example`. Each entrypoint
takes a run id and works only inside `runs/<run-id>/`, so stages can be re-run.

1. `bin/experiment-create <run-id>` - create the workstation and production VMs
2. `bin/experiment-prepare <run-id>` - install pinned tooling on both; the workstation reaches production as `prod`
3. `bin/experiment-launch <run-id>` - start the agent on the workstation with the prompt in `runs/<run-id>/prompt.md`
4. `bin/experiment-status <run-id>` - show the agent's state, usage so far, and how it ended
5. `bin/experiment-collect <run-id>` - pull the session, workspace, Docker state and logs from both machines
6. `bin/experiment-snapshot <run-id>` - power both machines off and snapshot them for the scorer
7. `bin/experiment-destroy <run-id>` - destroy the VMs; the run directory stays as the record

The host needs `tofu`, `uv` (which provides Ansible from the lock in `ansible/`), `jq`, `git` and `ssh-keygen`.

## Layout

- `bin/` operator entrypoints, `lib/` shared shell code they source, `libexec/` helpers they call
- `ansible/` the playbooks and roles that prepare the VMs, with the rendered inventories git-ignored
- `agent/` what runs on the workstation: the session wrapper, the token watchdog, one adapter per agent CLI
- `tf/<stage>/<provider>/` one OpenTofu root per stage and provider, all with the same variables and outputs
- `scripts/` development and CI checks, not part of operating an experiment
- `docs/design/` the premises of the design
- `runs/` per-run state, git-ignored
