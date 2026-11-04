# Scoring

Scoring is separate from running: its own entrypoints, run after any number of experiments, reading only
what [capture.md](capture.md) records plus the snapshots. It never adapts to a run; the prompt fixes
everything it checks ([task.md](task.md)).

## Three layers

- **Usage**, from the manifest and event stream, no machines: tokens by kind, the CLI's cost estimate,
  wall time from launch to exit, responses, tool calls, exit reason. Deterministic and free.
- **Correctness**, from the snapshots: the experiment root is applied again with the run's two
  snapshot ids, so a fresh pair boots as the agent left it on the same private addresses; a test
  bundle runs on the restored workstation; the pair is destroyed. The tests run there because only
  the workstation has the `prod` alias and the private network. One pair at a time.
- **Elegance**, from the workspace: a judge prompt with a fixed rubric, several samples per run
  through the API with the median kept, plus proxies that need no judgment: lines of code, files,
  dependencies, lint findings.

Each layer writes its record into the run directory; a report command folds any set of run directories
into one comparative document, pushed with them to the results repository.

## The acceptance tests

Every test is one line of the prompt read back:

- both health endpoints answer
- a registration reaches `completed` within a bound, and each side effect is checked at its source: the
  Keycloak user exists and logs in through the `scorer` client, the avatar is a 256x256 PNG fetched with
  the fixed credentials, the profile matches, exactly one Mailpit message carries the subject
- crash: during a registration every container on production not running one of the four given images
  is killed; the registration still completes and every count is still one. Whether the containers come
  back is the agent's restart policy, which is part of what is measured
- proxy cut: the mail proxy is disabled through Toxiproxy, several registrations start, the proxy is
  re-enabled; all complete, each with one email
- the reconciliation endpoint shows runs about a minute apart
- the profile survives a restart of its container
- a README exists in the workspace

Snapshots are the only source for restore. Rebuilding a deployment from the collected tarballs would
re-run the agent's steps and measure the scorer's deployment skill, not the agent's.

## Judging

The judge model and the number of samples are configuration, defaulting to Claude Opus through an API
key and five samples. The rubric is fixed text in the repository and is versioned like the prompt: a
change invalidates earlier elegance scores. The judge sees the workspace, not the framework's name
redacted, since the code imports it; the comparison is fair because every run gets the same rubric,
model and sample count.

## Why the scorer is a separate thing

The runner must not know what will be checked, or its design drifts toward the checks. The scorer must
not know how a run was produced, or its checks drift toward one framework's shape. Keeping them apart,
with the run directory as the only contract, is what makes the comparison a contest.
