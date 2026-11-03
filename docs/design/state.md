# State

The project is stateful on the experiments host, in git-ignored locations.

## Run directories

`runs/<run-id>/` is the state of one experiment and the only thing stages communicate through:

- `manifest.json`: parameters (framework, agent, model, tier, repetition, provider, region, sizes),
  prompt hash, playbook hash, provider image identifier, CLI versions, stage timestamps and exit state
- `tofu.tfstate` for the experiment root and `snapshot.tfstate` for the snapshot root
- the rendered inventory and the rendered prompt
- `artifacts/` from the collect stage

The tofu state in the run directory is how `destroy` finds the right machines later, so run directories
are never deleted while VMs may still exist.

## Parameters and secrets

- machine parameters (provider, region, sizes, image) in git-ignored `*.auto.tfvars` of the tofu roots
- credentials and defaults in a git-ignored `.env` loaded by the shared shell library
- model API keys reach the workstation only over SSH at launch, into the agent unit's environment, never
  through cloud-init user data where a metadata endpoint could expose them

## Run identity

Run ids are passed explicitly to every entrypoint. The matrix entrypoint only expands framework, agent,
tier and repetition into ids and parameters; it starts nothing.

## Results

Run directories are git-ignored here and committed to a separate results repository later. The
end-of-run snapshots live in the provider account and are referenced from the manifest.
