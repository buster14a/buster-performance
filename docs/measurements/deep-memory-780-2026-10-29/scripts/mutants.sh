#!/usr/bin/env bash
# #780's mutation check: each mutant, built from a copy of the worktree with one part of the fix undone, must fail the
# tests that cover it. $1: the worktree.
set -uo pipefail
tree="$1"
export CORES_TITLE="#780 deep memory classes: mutants" CORES_LINK="https://github.com/buster14a/buster/issues/780"
base=/home/david/.cache/claude-780/mutants
mutate()
{
    local name="$1" file="$2" from="$3" to="$4" tests="$5"
    local dir="$base/$name"
    rm -rf "$dir" && mkdir -p "$dir"
    (cd "$tree" && git ls-files -z | xargs -0 -I{} cp --parents {} "$dir")
    grep -qF "$from" "$dir/$file" || { echo "$name: pattern not found"; return; }
    sed -i "s|$from|$to|" "$dir/$file"
    (cd "$dir" && BUSTER_DEBUG_INFO=0 LC_NUMERIC=C cores -n 4 -- ./build.sh > build.log 2>&1) || { echo "$name: build failed"; return; }
    for t in $tests; do
        case "$t" in
            tier0) (cd "$dir" && cores -n 1 -- ./build/compiler test-tier0 > test-$t.log 2>&1) ;;
            checker) (cd "$dir" && env -u CPATH cores -n 4 -- ./build/compiler test-checker --seed 133 > test-$t.log 2>&1) ;;
        esac
        echo "$name: test-$t status $? ($(tail -1 "$dir/test-$t.log"))"
        grep -E "checks, [1-9][0-9]* failed|past-the-depth-tables" "$dir/test-$t.log" | head -6
    done
}
# The deep entries' slots named by their window's depths, not moved to their true depths.
mutate unshifted-slots src/buster/compiler/tier0.c 'tier0_emit_int128(function, entries, &shifted, homes, i, writer);' 'tier0_emit_int128(function, entries, frame, homes, i, writer);' tier0
# A deep call's long double argument read from its deep slot, as an integer's is.
mutate deep-call-long-double src/buster/compiler/tier0.c 'else if (pass == 0 && location.kind == BUSTER_ABI_LOCATION_STACK && tier0_class_x87(class))' 'else if (pass == 0 \&\& location.kind == BUSTER_ABI_LOCATION_STACK \&\& false)' checker
