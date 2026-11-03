# Shared shell code for bin/ entrypoints. Source it; do not execute it.
#
# Conventions: entrypoints run with `set -euo pipefail`, take the run id as
# their first argument, and touch nothing outside the run's directory, the
# tofu roots and the ansible inventory for that run. See docs/design/state.md.

# resolve_self <path>: absolute path with symlinks resolved where readlink -f
# exists; the fallback leaves symlinks alone, which is fine for a plain checkout.
resolve_self() {
	local path="$1" resolved
	if resolved="$(readlink -f "$path" 2>/dev/null)" && [[ -n "$resolved" ]]; then
		printf '%s' "$resolved"
	else
		printf '%s/%s' "$(cd "$(dirname "$path")" && pwd)" "$(basename "$path")"
	fi
}

# bin/, lib/ and libexec/ are siblings under the project root.
PROJECT_ROOT="$(dirname "$(dirname "$(resolve_self "${BASH_SOURCE[0]}")")")"
RUNS_DIR="$PROJECT_ROOT/runs"
TF_ROOTS_DIR="$PROJECT_ROOT/tf/roots"
ANSIBLE_DIR="$PROJECT_ROOT/ansible"

log() { printf '%s\n' "$*" >&2; }
die() {
	log "error: $*"
	exit 1
}

# require_cmd <name>...: abort unless every command is on PATH.
require_cmd() {
	local cmd
	for cmd in "$@"; do
		command -v "$cmd" >/dev/null 2>&1 || die "missing command: $cmd"
	done
}

# load_env: export every assignment in the project's .env, if present. Values
# are plain KEY=VALUE lines; quoting follows shell rules since the file is
# sourced. Tokens and keys are expected here, nowhere else.
load_env() {
	local env_file="$PROJECT_ROOT/.env"
	[[ -f "$env_file" ]] || return 0
	set -a
	# shellcheck disable=SC1090
	. "$env_file"
	set +a
}

# run_id_check <id>: run ids name directories and cloud resources, so they are
# restricted to lowercase letters, digits and dashes, starting with a letter.
run_id_check() {
	[[ "${1:-}" =~ ^[a-z][a-z0-9-]*$ ]] || die "invalid run id: '${1:-}'"
}

# run_dir <id>: the run's directory, created if needed.
run_dir() {
	run_id_check "$1"
	local dir="$RUNS_DIR/$1"
	mkdir -p "$dir"
	printf '%s' "$dir"
}

# manifest_path <id>, manifest_get <id> <jq-path>, manifest_set <id> <jq-path> <json-value>
#
# The manifest is one JSON object per run. Writes go through a temp file so a
# killed command never leaves a truncated manifest behind. Values are JSON, so
# strings must be passed quoted: manifest_set "$id" .framework '"waymark"'.
manifest_path() { printf '%s/manifest.json' "$(run_dir "$1")"; }
manifest_get() {
	local file
	file="$(manifest_path "$1")"
	[[ -f "$file" ]] || die "no manifest for run $1"
	jq -r "$2" "$file"
}
manifest_set() {
	local file tmp
	file="$(manifest_path "$1")"
	[[ -f "$file" ]] || printf '{}\n' >"$file"
	tmp="$(mktemp "$file.XXXXXX")"
	jq --argjson value "$3" "$2 = \$value" "$file" >"$tmp" && mv "$tmp" "$file"
}

# now_utc: timestamps in the manifest are RFC 3339 in UTC.
now_utc() { date -u +%Y-%m-%dT%H:%M:%SZ; }

# tofu_root <root-name> <run-id> <tofu-args>...: run OpenTofu in tf/roots/<root>
# with the run's own state file, so one root serves every run. The provider
# and sizes come from the root's git-ignored *.auto.tfvars; per-run values are
# passed by the caller as -var flags.
tofu_root() {
	local root="$1" id="$2"
	shift 2
	require_cmd tofu
	[[ -d "$TF_ROOTS_DIR/$root" ]] || die "no tofu root: $root"
	tofu -chdir="$TF_ROOTS_DIR/$root" "$@" -state="$(run_dir "$id")/$root.tfstate"
}

# ansible_playbook <run-id> <playbook-name> <ansible-args>...: run a playbook
# from ansible/playbooks against the run's rendered inventory.
ansible_playbook() {
	local id="$1" playbook="$2"
	shift 2
	require_cmd ansible-playbook
	local inventory="$ANSIBLE_DIR/inventory/$id.ini"
	[[ -f "$inventory" ]] || die "no inventory for run $id; run experiment-prepare"
	ansible-playbook -i "$inventory" "$ANSIBLE_DIR/playbooks/$playbook.yml" "$@"
}
