#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "$1")
out=$(realpath -m "$2")
mode=${3:-plain}
here=$(cd "$(dirname "$0")" && pwd)
gen=${BODY_INPUTS:-"$here/generated"}
mkdir -p "$out" "$gen"
cc -O2 "$here/corpus.c" -o "$gen/corpus"
for n in 64 128; do
    "$gen/corpus" "$n" 0 > "$gen/n$n-left.c"
    "$gen/corpus" "$n" 1 > "$gen/n$n-right.c"
done
run() {
    local name=$1
    shift
    local status=0
    if [[ "$mode" == probe ]]; then
        BUSTER_BODY_TRACE="$out/$name.trace" "$compiler" interpret-c "$@" >"$out/$name.out" 2>"$out/$name.err" || status=$?
    else
        "$compiler" interpret-c "$@" >"$out/$name.out" 2>"$out/$name.err" || status=$?
    fi
    printf '%s\n' "$status" >"$out/$name.status"
}
for n in 64 128; do
    run "n$n" "$gen/n$n-left.c" "$gen/n$n-right.c"
done
f="$here/fixtures"
run units tests/interpreter/units-main.c tests/interpreter/units-library.c
run units-reversed tests/interpreter/units-library.c tests/interpreter/units-main.c
run calls "$f/calls-main.c" "$f/calls-middle.c" "$f/calls-library.c"
run calls-reversed "$f/calls-library.c" "$f/calls-middle.c" "$f/calls-main.c"
run entry-alias "$f/entry-alias.c"
run weak-entry "$f/weak-main.c"
run weak-strong "$f/weak-main.c" "$f/strong-main.c"
run strong-weak "$f/strong-main.c" "$f/weak-main.c"
run duplicate "$f/strong-main.c" "$f/other-main.c"
run missing "$f/missing.c"
run no-main "$f/no-main.c"
run no-body "$f/no-body.c"
run step-limit --steps 1 "$f/strong-main.c"
if [[ "$mode" == probe ]]; then
    for edge in original first middle last first-interior aligned-interior last-interior one-past below zero max unrelated beyond-u32; do
        BUSTER_BODY_EDGE="$edge" run "edge-$edge" "$f/edge.c"
    done
fi
