#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
exec 8> .campaign-queue.lock
flock -n 8 || exit 0
[[ ! -e .campaign-complete ]] || exit 0
export EXCLUSIVE_OWNER=codex-601 EXCLUSIVE_TITLE='Buster 601 static bit-field comparison' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/601
for phase in preflight 'whole 1' 'whole 2' stages; do
  printf '%s queued\n' "$phase"
  read -r -a arguments <<< "$phase"
  ~/buster-fast-bench/exclusive.sh bash evidence/measure.sh "${arguments[@]}"
done
bash evidence/measure.sh split
touch .campaign-complete
printf 'campaign complete\n'
