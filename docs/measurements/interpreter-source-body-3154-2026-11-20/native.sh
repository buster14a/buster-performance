#!/usr/bin/env bash
set -euo pipefail
out=$(realpath -m "$1")
here=$(cd "$(dirname "$0")" && pwd)
gen=${BODY_INPUTS:-"$here/generated"}
f=$here/fixtures
mkdir -p "$out"
run() {
    local name=$1 status=0
    shift
    "${CLANG:-clang}" -O0 -std=gnu17 "$@" -o "$out/program"
    env -i -a program "$out/program" > "$out/$name.out" 2> "$out/$name.err" || status=$?
    printf '%s\n' "$status" >"$out/$name.status"
}
run units tests/interpreter/units-main.c tests/interpreter/units-library.c
run units-reversed tests/interpreter/units-library.c tests/interpreter/units-main.c
run calls "$f/calls-main.c" "$f/calls-middle.c" "$f/calls-library.c"
run calls-reversed "$f/calls-library.c" "$f/calls-middle.c" "$f/calls-main.c"
run entry-alias "$f/entry-alias.c"
run weak-entry "$f/weak-main.c"
run weak-strong "$f/weak-main.c" "$f/strong-main.c"
run strong-weak "$f/strong-main.c" "$f/weak-main.c"
for n in 64 128; do
    run "n$n" "$gen/n$n-left.c" "$gen/n$n-right.c"
done
rm "$out/program"
