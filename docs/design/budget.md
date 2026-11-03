# Budget

A run is bounded in three ways, in order of preference.

## Token cap

The primary limit, because tokens are what is being measured. Neither agent CLI enforces a token cap
natively (Claude Code offers a dollar cap), so a watchdog on the workstation keeps running totals and
stops the agent when the cap is crossed. It runs inside the agent's systemd unit so it cannot be lost with
the SSH connection from the host.

The cap applies to the total of all token kinds: input, output, cache reads and cache writes. Cache reads
dominate that total for every agent, but they are what the provider bills and what grows with every turn,
so they are the honest measure of how much context a run consumed. The four kinds are recorded separately
so other readings remain possible.

Claude Code reports usage on its event stream per API response and the watchdog deduplicates by message.
Codex reports usage on its stream only when the whole turn ends, so for Codex the watchdog follows the
cumulative counts in the session rollout the CLI writes to disk.

## Turn cap

A backstop against an agent that loops without spending many tokens. Set through the CLI where it exists:
Claude Code has a flag for it, Codex has none, so for Codex only the token and wall-clock caps apply.

## Wall-clock cap

The final backstop, enforced twice: by the unit on the workstation, and by the host, which destroys the
pair at a hard deadline regardless of what the unit reports.

## A capped run is a result

A run stopped by any cap is recorded with its exit state and everything it produced so far. It is not
discarded and not retried in place: "did not finish within the budget" is a measurement.

## Spend

Each agent uses a dedicated API key with a provider-side spend limit. The agent runs with permission
prompts bypassed and can read its own environment, so the key must not be one that matters elsewhere.
