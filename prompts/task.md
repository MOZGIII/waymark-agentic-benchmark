<!--
The frozen task prompt. {{framework}} is the only substitution; the docs tier
appends prompts/tiers/docs.md. Every run records the hash of this file and of
the text it received. Changing anything here invalidates earlier results.
Comment blocks like this one are stripped by libexec/render-prompt.

The task body below is a placeholder until the sample app is specified; see
docs/design/task.md.
-->

# Task

TODO: the sample application, its behaviour, and what "done" means.

## Environment

You are on a fresh Debian workstation as user `dev`, with passwordless sudo and Docker. A production
server is reachable over SSH as `prod`: user `deploy`, passwordless sudo, Docker installed, nothing else.
There is no CI and no container registry. Build images on the workstation and move them to `prod`
yourself. Use {{framework}} for the background work.
