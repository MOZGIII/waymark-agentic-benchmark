# Goal

Measure how well coding agents build and deploy a real application with waymark compared to competing
durable-workflow frameworks. The waymark developers use the result to find and fix what makes waymark
harder for an agent than it should be.

## What is compared

Every cell of the matrix runs the same task from the same prompt. Only these vary:

- framework: waymark and, in the first round, Temporal, Hatchet, DBOS, Celery
- agent: Claude Code and Codex, each at a pinned version and model
- tier: `bare` (prompt only) or `docs` (prompt plus one line pointing at the framework's docs root)
- repetition: at least three per cell, because agent output is stochastic

Python only for now.

## What is measured

Per run, from the agent's own event stream and the collected artifacts:

- tokens, split into input, output, cache read and cache write; dollars derived from them
- wall time and number of turns and tool calls
- whether the run finished, hit the budget, or failed

Separately and later, by an independent comparative scorer (see [scoring.md](scoring.md)):

- correctness, via acceptance tests that never import the framework
- elegance of the produced code and deployment

## What is not the goal

Not a throughput or latency benchmark of the frameworks themselves. Not a benchmark of the agents
against each other, although the data allows that reading. The prompt is not a place to make waymark
look good: improvements go into waymark's API and docs, never into the task text.
