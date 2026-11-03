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

- the agent's workspace as a tarball, including lockfiles, any Dockerfiles and its git history
- the agent CLI's home directories, where Claude Code and Codex keep their own session transcripts
- the Docker state: image and container lists
- the system journal and a package dump, the latter also taken after preparation

Dependency directories (node_modules, virtualenvs, caches) are left out of every tarball. Lockfiles
record what they held, and they would dominate the archive without adding information.

## From production

- the container list, images, and the full inspection of every container as the agent left them
- the logs of every container
- the deploy user's home and the usual deployment locations, where compose files and configs end up
- the system journal and the same package dumps

## Snapshots

Both VMs are powered off and snapshotted after collection and before destruction, so the disks are
consistent. The scorer can then boot the exact machines the agent left behind and run acceptance tests
against the deployed app, instead of trying to rebuild that state from files and re-running the agent's
deployment steps. Retention is decided once the
scorer exists; snapshots are the faithful option, files are the cheap one.

## Web traffic

Agents fetch documentation and packages themselves. The transcript shows only a summary of each fetch, so
the raw responses are not currently captured. A recording proxy on the workstation would give full
traceability and the option of replay; it is a candidate addition, not part of the first round.
