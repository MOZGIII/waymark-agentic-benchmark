# Lifecycle of one experiment

Each stage is its own operator entrypoint, run in order by hand or by the convenience wrapper. Every
stage reads and writes only the run's directory (see [state.md](state.md)), so a stage can be re-run or
a run resumed after a failure.

| Stage    | Does                                                                     | Produces              |
|----------|--------------------------------------------------------------------------|-----------------------|
| create   | OpenTofu applies the experiment root: network, two VMs, per-run key      | tofu state, manifest  |
| prepare  | renders the inventory, runs the workstation and production playbooks     | inventory, package dumps |
| launch   | pushes the prompt and run config over SSH, starts the agent unit         | launch record         |
| status   | polls the unit, shows usage so far                                       | nothing               |
| collect  | pulls artifacts from both VMs                                            | artifacts             |
| snapshot | OpenTofu applies the snapshot root for both VMs                          | snapshot state        |
| destroy  | OpenTofu destroys the experiment root                                    | manifest exit record  |

## Why launch is explicit SSH

The agent is started as a transient systemd unit on the workstation. The host can then poll its state,
read its journal and kill it cleanly, and the budget watchdog (see [budget.md](budget.md)) runs inside
the same unit, so it keeps working if the SSH session from the host drops.

## Why snapshot is a separate root

OpenTofu destroys dependents before their dependencies. A snapshot declared next to its server would be
deleted before the server. Keeping it in its own root with its own state lets the experiment root be
destroyed normally while the snapshots survive.

## Why the pair is created on demand

A fresh pair per run is the cheapest way to guarantee no state leaks between runs. VM time is negligible
next to model tokens, and parallel runs on separate VMs do not contend for CPU, so wall time stays
meaningful.
