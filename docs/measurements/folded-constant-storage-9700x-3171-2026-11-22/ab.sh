#!/usr/bin/env bash
# ab.sh ROUNDS RUNS: the base (main the PR head last merged), the PR head, and the base again (the floor), each from
# 2 fresh copies, by time-runs under ab on CPU 2, each time-runs process one hold of the lock: -c of the frozen
# sqlite3.c with the 9700X job's options.
set -uo pipefail
. "$HOME/buster-fast-bench/3022-claude/env.sh"
cd "$W"
rounds=${1:-6}
runs=${2:-7}
cp bin/base bin/harness
out=/dev/shm/claude3171-out
copies=/dev/shm/claude3171-copies
mkdir -p "$out" "$copies"
builds=(--build main "$W/bin/base" --build head "$W/bin/head" --build main-again "$W/bin/base")
stamp=$(date -u +%H%M%S)
log="$W/logs/ab-$stamp.log"
echo "$log"
(cd "$out" && "$W/bin/harness" ab --rounds "$rounds" --cpu 2 --lock "$W/lockwrap.sh" "$W/bin/harness" \
    -- time-runs --runs "$runs" --copies 2 --directory "$copies" "${builds[@]}" --list "${OPTIONS[@]}" -o "$out/runs.o") > "$log" 2>&1
echo "ab exit $?" >> "$log"
touch ab.done
