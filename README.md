# waymark-agentic-benchmark

Machinery for measuring how coding agents build and deploy one sample application with waymark versus
competing durable-workflow frameworks: same frozen prompt, fresh cloud VMs per run, tokens and time
recorded, results scored separately. The reasoning behind the setup is in [docs/design](docs/design).

This repository is for the machinery only. The code the agents produce and the reports live elsewhere.

## Layout

- `lib/` shared shell code sourced by the operator entrypoints
- `docs/design/` the premises of the design
- `runs/` per-run state, git-ignored
