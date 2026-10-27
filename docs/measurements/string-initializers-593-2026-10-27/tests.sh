#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../head"
root=$(pwd)/../evidence
export EXCLUSIVE_OWNER=codex-593
export EXCLUSIVE_TITLE="Buster #593 compiler validation"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/593
lock="$HOME/buster-fast-bench/exclusive.sh"
mkdir -p "$root/logs"
run()
{
    local name=$1
    shift
    echo "test=$name"
    "$lock" bash -c 'log=$1; shift; "$@" > "$log" 2>&1' validation "$root/logs/$name.log" "$@" \
        > "$root/logs/$name-lock.log" 2>&1
    echo "test=$name status=0"
}
run test-checker ./build/compiler test-checker --seed 133
run test-checker-deferred ./build/compiler test-checker-deferred
run test-checker-driver ./build/compiler test-checker-driver --executable ./build/compiler
run test-c-testsuite ./build/compiler test-c-testsuite --cross-check --clang /usr/bin/clang --jobs 8 --subset tests/c-testsuite/subset.txt build/c-testsuite
run call-graph ./build.sh check-call-graph
echo 'validation status=0'
