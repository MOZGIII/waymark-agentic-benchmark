<!--
The frozen task prompt. {{framework}} is the only substitution; the docs tier
appends prompts/tiers/docs.md. Every run records the hash of this file and of
the text it received. Changing anything here invalidates earlier results.
Comment blocks like this one are stripped by libexec/render-prompt.
The premises behind the task are in docs/design/task.md.
-->

# Task

Build and deploy a user registration system in Python. Registering a user must create their login,
generate and store their avatar, create their profile, and send them a welcome email. Use {{framework}}
for the durable background work.

## Services you deploy as given

Run these on `prod` at exactly these versions and ports. Do not replace any of them with your own
implementation.

- Keycloak `quay.io/keycloak/keycloak:26.8.1`, HTTP on port 8180, realm `app` with a public client
  `scorer` that has direct access grants enabled. Registration creates the user here; its Keycloak
  user id is the user id everywhere else.
- Mailpit `axllent/mailpit:v1.33.0`, SMTP on port 1025, HTTP API on port 8025.
- Garage `dxflrs/garage:v2.5.0`, S3 API on port 3900, region `garage`, with a bucket `avatars` and an
  imported key with access key id `GK0000000000000000000ba5eb` and secret
  `0000000000000000000000000000000000000000000000000000000000ba5eba` that has read and write on that
  bucket.
- Toxiproxy `ghcr.io/shopify/toxiproxy:2.13.0`, API on port 8474, with a proxy named `mailpit`
  listening on port 1026 and forwarding to Mailpit's SMTP port. Send all mail through port 1026, never
  directly to Mailpit.

## Services you write

### registration, port 8080

- `POST /registrations` with JSON `{"email", "password", "display_name"}`. Returns 202 and `{"id"}`
  at once; the work happens in the background.
- `GET /registrations/{id}` returns `{"id", "email", "state", "user_id", "steps", "created_at",
  "completed_at"}`. `state` is `pending`, `completed` or `failed`. `steps` maps `auth`, `avatar`,
  `profile` and `email` each to `pending`, `done` or `failed`.
- `GET /reconciliations` returns the last 20 runs of the reconciliation job as
  `[{"started_at", "finished_at", "resumed"}]`, newest first.
- `GET /healthz` returns 200 when the service can accept registrations.

A registration is `completed` when all four steps are done: the Keycloak user exists and can log in
with the password, the avatar object is at `s3://avatars/{user_id}.png` on the Garage endpoint, the
profile exists, and the welcome email has been delivered to Mailpit with the subject
`Welcome, {display_name}`.

### profile, port 8081

- `PUT /profiles/{user_id}` with JSON `{"email", "display_name", "avatar_url"}` creates or replaces
  the profile; returns 201 on create, 200 on replace. `avatar_url` is
  `http://prod:3900/avatars/{user_id}.png`.
- `GET /profiles/{user_id}` returns the same fields plus `"created_at"`, or 404.
- `GET /healthz` returns 200.

Profiles live in a store of your choice that survives restarts.

## Requirements

- Every side effect happens exactly once per registration: one Keycloak user, one avatar object, one
  profile, one email. This holds when any of your processes or containers is killed at any moment and
  restarted; the registration must still reach `completed` without manual intervention.
- Mail delivery is retried: the SMTP path will be cut for stretches of time, and registrations
  started during such a stretch must still complete once it heals, without duplicate emails.
- A reconciliation job runs every minute, finds registrations that have been `pending` for more than
  two minutes, and resumes them. Each run is listed at `/reconciliations`.
- The avatar is a 256x256 PNG generated from the display name's initials.

## Done

Everything runs on `prod`, built from Dockerfiles in your workspace, and keeps running after you
disconnect. A registration round-trips end to end from the workstation with `curl` against `prod`'s
addresses above. Leave a `README.md` in the workspace saying how to deploy and how you verified it.

## Environment

You are on a fresh Debian workstation as user `dev`, with passwordless sudo and Docker. A production
server is reachable over SSH as `prod`: user `deploy`, passwordless sudo, Docker installed, nothing else.
There is no CI and no container registry. Build images on the workstation and move them to `prod`
yourself.
