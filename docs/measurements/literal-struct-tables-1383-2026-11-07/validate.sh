#!/bin/bash
set -u
cd "$HOME/buster-fast-bench/1383-struct-codex/pr" || exit 1
for ((attempt=0;attempt<120;attempt++)); do
    if grep -q "published as build/compiler" ../candidate-build.log; then
        break
    fi
    if grep -qE 'FAILED:|error:' ../candidate-build.log; then
        echo candidate-build-failed
        exit 2
    fi
    sleep 5
done
grep -q "published as build/compiler" ../candidate-build.log || exit 2
export EXCLUSIVE_OWNER=codex-1383-struct
export EXCLUSIVE_TITLE="Recover direction 3 of 1383: native validation"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1383
result=0
run()
{
    local name=$1
    shift
    "$HOME/buster-fast-bench/exclusive.sh" "$@" > "../$name.log" 2>&1
    local code=$?
    echo "$name: $code"
    if test "$code" -ne 0; then
        result=1
    fi
}
run checker ./build/compiler test-checker --seed 133
run deferred ./build/compiler test-checker-deferred
run units ./build/compiler test-check-units
for part in 1 2 3 4; do
    run "driver-$part" ./build/compiler test-checker-driver --executable ./build/compiler --part "$part/4"
done
printf 'validation-status=%s\n' "$result"
exit "$result"
