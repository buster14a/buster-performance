#!/bin/bash
# #2630 step 2's build times on the 9700X: each measured build its own hold (lock.sh, held.sh), the configurations in
# turns. TREES are src (the setting as it is) and lanes1 (its previous-stage compiles at --lanes 1).
set -u
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
L=$d/scripts/lock.sh; H=$d/scripts/held.sh; S=$d/scripts/step.sh
out=$d/results/builds
mkdir -p "$out" "$d/tmp"
n=0
for tree in src lanes1; do
    t=$d/$tree
    "$L" "$H" "$out/$tree.log" bash -c 'cd "$1" && unset BUSTER_SELF_BUILT && ./build.sh --config Release' prep "$t"
    for round in 1 2 3; do
        for cfg in off tests; do
            [ "$tree" = lanes1 ] && [ "$cfg" = off ] && continue
            "$L" "$H" "$out/$tree.log" "$S" "$t" clean "$cfg"
            "$L" "$H" "$out/$tree.log" "$S" "$t" noop "$cfg"
        done
    done
    files="src/buster/compiler/differential.c src/buster/compiler/x86_64_encoder.c src/buster/compiler/tier0.c src/buster/compiler/c_check_input.c src/buster/compiler/emission_metadata.c"
    [ "$tree" = lanes1 ] && files="src/buster/compiler/differential.c src/buster/compiler/tier0.c"
    for round in 1 2; do
        for file in $files; do
            for cfg in off tests; do
                [ "$tree" = lanes1 ] && [ "$cfg" = off ] && continue
                n=$((n + 1))
                "$L" "$H" "$out/$tree.log" "$S" "$t" edit "$cfg" "$t/$file" "$n"
            done
        done
    done
done
grep -h '^result' "$out"/*.log.out > "$out/results.tsv"
echo builds-done
