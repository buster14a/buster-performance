#!/bin/bash
# The campaign's rest, detached: builds2.sh's last edits of its second round (stopped while it waited for the lock,
# with the --lanes 1 variant left out for the lock's contention), then the executables' copies and the run times.
set -u
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
L=$d/scripts/lock.sh; H=$d/scripts/held.sh; S=$d/scripts/step.sh
out=$d/results/builds
t=$d/src
n=12
"$L" "$H" "$out/src.log" "$S" "$t" edit tests "$t/src/buster/compiler/x86_64_encoder.c" "$n"
for file in tier0.c c_check_input.c; do
    for cfg in off tests; do
        n=$((n + 1))
        "$L" "$H" "$out/src.log" "$S" "$t" edit "$cfg" "$t/src/buster/compiler/$file" "$n"
    done
done
grep -h '^result' "$out"/*.log.out > "$out/results.tsv"
echo builds-done
"$L" "$H" "$d/results/copies.log" "$d/scripts/copies.sh"
"$d/scripts/runtime.sh"
echo campaign-done
