# Task

The sample application is a user registration system: registering a user creates their login, stores
a generated avatar, creates their profile and sends a welcome email. The prompt text itself is
[prompts/task.md](../../prompts/task.md); this records why it says what it says.

## Off-the-shelf services, chosen in the prompt

Auth, mail, object storage and fault injection are existing services the agent deploys, pinned to an
image tag: Keycloak, Mailpit, Garage and Toxiproxy. Real or stub does not matter; agent-written does.
Most users reach for an existing service rather than inventing one, every framework faces the same
services, and the elegance comparison stays about the framework instead of about who wrote the better
mail stub. The prompt forbids replacing them so an agent cannot dodge a slow start-up with a fake.

Garage over MinIO because MinIO stopped releasing in 2025. Garage has no anonymous bucket reads, so
the S3 credentials are fixed in the prompt and the scorer reads avatars with them.

## Agent-written services, with a fixed API

Two services are the agent's: registration, the orchestrator that holds the durable work, and
profile, the stand-in for application-specific code. Their endpoints, ports, payloads and states are
spelled out in the prompt so the scorer tests every run identically; anything the scorer had to adapt
per run would be a place for bias. What is left open is where frameworks differ: database, worker
layout, how images reach production, how the framework's own server is run.

## Requirements the scorer can test from outside

- Exactly-once side effects under crashes: the scorer kills a process mid-registration and checks
  one Keycloak user, one object, one profile, one email, and a `completed` state.
- Retries: real services are not flaky, so Toxiproxy sits on the mail path and the scorer cuts it for
  a while. Mail goes through the proxy by rule, otherwise the test is meaningless.
- Scheduling: a reconciliation job every minute that resumes registrations pending for over two
  minutes, listed at an endpoint. The two constants fix the scorer's timing; shorter would penalise
  frameworks with slow pollers.
- Deployment: everything on production, built from Dockerfiles, surviving the agent's disconnect.

## Not in the task

No frontend, no email verification flow, no deletion. One registration at a time is enough to measure;
throughput is not the goal.
