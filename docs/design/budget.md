# Budget

A run is bounded in three ways, in order of preference.

## Token cap

The primary limit, because tokens are what is being measured. Neither agent CLI enforces a token cap
natively (Claude Code offers a dollar cap), so a watchdog on the workstation tails the agent's JSON event
stream, sums usage, and kills the agent when the cap is crossed. It runs inside the agent's systemd unit
so it cannot be lost with the SSH connection from the host.

## Turn cap

A backstop against an agent that loops without spending many tokens. Set through the CLI where it exists.

## Wall-clock cap

The final backstop, enforced twice: by the unit on the workstation, and by the host, which destroys the
pair at a hard deadline regardless of what the unit reports.

## A capped run is a result

A run stopped by any cap is recorded with its exit state and everything it produced so far. It is not
discarded and not retried in place: "did not finish within the budget" is a measurement.

## Spend

Each agent uses a dedicated API key with a provider-side spend limit. The agent runs with permission
prompts bypassed and can read its own environment, so the key must not be one that matters elsewhere.
