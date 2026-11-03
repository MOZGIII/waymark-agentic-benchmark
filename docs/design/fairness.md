# Fairness

## One frozen prompt

The task prompt is a single text with one substitution point for the framework name. Any other
difference between cells is a bug. Changing the prompt invalidates every earlier result, so the prompt is
versioned and each run records the hash of the exact text it received.

The task must not resemble waymark's own example app, and it must exercise what all candidate frameworks
are for: fan-out, retries, scheduling, surviving a crash, and getting deployed.

## Training-data asymmetry

Models have seen years of Temporal and Celery code and almost none for waymark. A bare run therefore
measures familiarity as much as ergonomics. That is accepted on purpose: it is what a user gets today.

The `docs` tier adds exactly one line per framework pointing at its documentation root, which is what
people actually type. Nothing more is supplied: no vendored documentation, no hints, no starter code. The
agent fetches what it needs, and what it fetched is captured (see [capture.md](capture.md)).

## Same machines, same budget

Every run gets an identical pair of freshly created VMs from the provider's stock Debian image, prepared
by the same playbooks with pinned versions, and the same token, turn and time caps. The agent installs
and configures everything the framework needs by itself, on both machines, because setup effort is part
of what is measured.

## Repetition over single runs

A single run of an agent is noise. Cells are repeated and reported as median with spread. Decisions about
waymark are made on paired comparisons across repetitions, never on one run.

## Guarding against overfitting

Because the authors of this benchmark also develop one of the frameworks, three rules apply:

- the prompt is reviewed for neutrality before it is frozen and is not edited to favour any framework
- every framework runs on the same provider, region, machine class and tier set
- waymark fixes motivated by a run are made in waymark and then re-benchmarked under the unchanged prompt
