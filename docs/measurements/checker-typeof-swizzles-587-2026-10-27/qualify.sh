#!/usr/bin/env bash
set -uo pipefail
cd "$HOME/buster-fast-bench/issue587-codex-20261027"
export EXCLUSIVE_OWNER=codex-issue587
export EXCLUSIVE_TITLE='Fix typeof of extension-vector swizzles (#587)'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/587
export BUSTER_DEBUG_INFO=0
export TMPDIR="$PWD/tmp"
mkdir -p "$TMPDIR" results
run()
{
    local name=$1
    shift
    "$HOME/buster-fast-bench/exclusive.sh" "$@" > "results/$name.log" 2>&1
    local rc=$?
    printf '%s\n' "$rc" > "results/$name.rc"
    printf '%s: %s\n' "$name" "$rc"
    return "$rc"
}
cp src/buster/compiler/c_check_constant.c c_check_constant.fixed.c
cp c_check_constant.base.c src/buster/compiler/c_check_constant.c
run baseline-build ./build.sh || exit 1
cp build/compiler baseline-compiler
run baseline-checker ./baseline-compiler test-checker --seed 133
cp c_check_constant.fixed.c src/buster/compiler/c_check_constant.c
run fixed-build ./build.sh || exit 1
cp build/compiler fixed-compiler
run fixed-checker ./fixed-compiler test-checker --seed 133
run fixed-deferred ./fixed-compiler test-checker-deferred
run fixed-call-graph ./build.sh check-call-graph
printf 'qualification complete\n'
