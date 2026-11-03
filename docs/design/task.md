# Task

The sample application is not yet specified. It gets its own planning pass before the prompt is frozen.

Requirements it must meet, from [fairness.md](fairness.md) and [environment.md](environment.md):

- exercise fan-out, retries against a flaky dependency, a scheduled job and surviving a worker crash
- end with the app deployed and running on the production VM, built from Dockerfiles on the workstation
- be checkable by black-box acceptance tests that never import the framework
- be small enough to finish within one agent session under the budget
- not resemble waymark's own example app

Candidates under discussion: a user-registration flow fanning out to auth, avatar and email services;
a document-ingestion pipeline.
