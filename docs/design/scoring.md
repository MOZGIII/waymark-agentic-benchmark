# Scoring

Not yet designed. What is settled:

- scoring is a separate process from running experiments, with its own entrypoint and its own agent
- it works comparatively across all run artifacts of a matrix, not one run at a time
- it consumes only what [capture.md](capture.md) records, booting snapshots where it needs a live app
- correctness comes from acceptance tests that never import the framework
- elegance is judged by a fixed rubric applied several times, plus objective proxies such as size, file
  count and lint results
