# Decisions

One line each, dated, with the reason. Newest last.

- 2026-11-03 One frozen prompt with a single framework substitution: any other difference is a confound.
- 2026-11-03 Two tiers, bare and docs; no vendored docs: mirrors real use, fetched content is captured instead.
- 2026-11-03 First round: waymark, Temporal, Hatchet, DBOS, Celery; Python only; Claude Code and Codex.
- 2026-11-03 Nothing runs near the developers' machines: an experiments host VM drives per-run cloud VMs.
- 2026-11-03 Two targets per run, workstation and production: deployment is part of the task.
- 2026-11-03 Production has Docker preinstalled and nothing else: installing it is equal work for everyone.
- 2026-11-03 Same architecture (x86_64) and size for both targets: no cross-build noise, no starvation.
- 2026-11-03 Stock cloud images plus Ansible, no golden image: nothing to build or store; manifest records versions.
- 2026-11-03 No Packer: no open fork exists and its build shape cannot host an agent session.
- 2026-11-03 OpenTofu for infrastructure, one module per provider behind a fixed interface; Hetzner and Linode.
- 2026-11-03 Agent launched over explicit SSH as a systemd unit, with the token watchdog inside the unit.
- 2026-11-03 Snapshots of both VMs after each run, in a separate tofu root, for the scorer; retention open.
- 2026-11-03 Stages are separate operator entrypoints sharing a run directory; the host stays stateless otherwise.
- 2026-11-03 Scoring is a separate, independent, comparative process; design deferred.
- 2026-11-03 Bash for orchestration; other languages allowed in bin where bash is a poor fit.
