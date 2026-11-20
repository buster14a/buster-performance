#!/usr/bin/env bash
# A busy measurement host returns 75. Use the shared wrapper without joining its blocking flock path.
set -u
if [[ -s /var/lib/buster-9700x/owner || -e /var/lib/buster-9700x/ci-waiting ]] || pgrep -x Runner.Worker >/dev/null || pgrep -x flock >/dev/null; then exit 75; fi
if ps -eo stat=,pcpu=,etimes=,comm= | awk '$1 ~ /^R/ && $2 >= 50 && $3 >= 3 {busy=1} END{exit !busy}'; then exit 75; fi
flock() {
    if [[ $1 != -n ]]; then exit 75; fi
    command flock "$@"
}
export EXCLUSIVE_OWNER='codex-01a1f5e5'
export EXCLUSIVE_TITLE="${MEASUREMENT_TITLE:?}"
export EXCLUSIVE_LINK="${MEASUREMENT_LINK:?}"
set +u
source "$HOME/buster-fast-bench/exclusive.sh" "$@"
