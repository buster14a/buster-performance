#!/bin/bash
# usage: suites.sh TREE OUT: the checker suites with TREE's build/compiler, under one hold of the lock per suite.
set -u
. "$(dirname "$0")/common.sh"
tree="$base/$1"; out="$base/$2"; mkdir -p "$out"; cd "$tree"
run()
{
    local name="$1"; shift
    held "$out/$name.receipt" bash -c '"$@"' run "$@" > "$out/$name.txt" 2>&1
    echo "$name status=$?" | tee -a "$out/status.txt"
}
run test-checker ./build/compiler test-checker --seed 133
run test-checker-driver ./build/compiler test-checker-driver --executable ./build/compiler
run test-checker-asm ./build/compiler test-checker-asm
run test-check-lanes ./build/compiler test-check-lanes
run test-check-units ./build/compiler test-check-units
run test-check-debug ./build/compiler test-check-debug --cross-check
run test-checker-deferred ./build/compiler test-checker-deferred
run test-builtins ./build/compiler test-builtins
