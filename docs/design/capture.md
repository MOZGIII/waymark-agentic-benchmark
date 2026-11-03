# Capture

Everything needed to explain or re-examine a run is recorded, because no two agent runs are alike and
nothing can be re-derived afterwards.

## From the agent

- the full JSON event stream the agent CLI emits, including per-turn token usage
- the transcript and any session files the CLI keeps
- the unit's journal

The event stream is what the budget watchdog consumes and what the usage metrics are computed from, so it
is the primary artifact.

## From the workstation

- the agent's workspace as a tarball, including lockfiles and any Dockerfiles
- the Docker state: image list, build logs if kept
- a package dump taken after preparation and again at collection

## From production

- the container list, images, compose files and other deployment files as the agent left them
- container logs
- the same package dumps

## Snapshots

Both VMs are snapshotted after collection and before destruction. The scorer can then boot the exact
machines the agent left behind and run acceptance tests against the deployed app, instead of trying to
rebuild that state from files and re-running the agent's deployment steps. Retention is decided once the
scorer exists; snapshots are the faithful option, files are the cheap one.

## Web traffic

Agents fetch documentation and packages themselves. The transcript shows only a summary of each fetch, so
the raw responses are not currently captured. A recording proxy on the workstation would give full
traceability and the option of replay; it is a candidate addition, not part of the first round.
