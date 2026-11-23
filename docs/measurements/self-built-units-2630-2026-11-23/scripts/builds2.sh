#!/bin/bash
# #2630 step 2's build times on the 9700X, trimmed to fewer holds after the lock's contention (a no-op build rides each
# clean one's hold): each measured build its own hold (lock.sh, held.sh), the configurations in turns. TREES are src
# (the setting as it is) and lanes1 (its previous-stage compiles at --lanes 1). src's Release, the previous stage, was
# built by builds.sh's first hold, and its first clean build with the setting off kept (results/builds/src.log.out).
set -u
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
L=$d/scripts/lock.sh; H=$d/scripts/held.sh; S=$d/scripts/step.sh
out=$d/results/builds
mkdir -p "$out" "$d/tmp"
t=$d/src
"$L" "$H" "$out/src.log" "$S" "$t" clean tests
for round in 2 3; do
    for cfg in off tests; do
        "$L" "$H" "$out/src.log" "$S" "$t" clean "$cfg"
    done
done
n=0
for round in 1 2; do
    for file in differential.c x86_64_encoder.c tier0.c c_check_input.c; do
        for cfg in off tests; do
            n=$((n + 1))
            "$L" "$H" "$out/src.log" "$S" "$t" edit "$cfg" "$t/src/buster/compiler/$file" "$n"
        done
    done
done
t=$d/lanes1
"$L" "$H" "$out/lanes1.log" bash -c 'cd "$1" && unset BUSTER_SELF_BUILT && ./build.sh --config Release' prep "$t"
for round in 1 2; do
    "$L" "$H" "$out/lanes1.log" "$S" "$t" clean tests
done
for file in differential.c tier0.c; do
    n=$((n + 1))
    "$L" "$H" "$out/lanes1.log" "$S" "$t" edit tests "$t/src/buster/compiler/$file" "$n"
done
grep -h '^result' "$out"/*.log.out > "$out/results.tsv"
echo builds-done
