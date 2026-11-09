#!/bin/bash
set -eu
cd "$HOME/buster-fast-bench/1383-struct-codex"
for ((attempt=0;attempt<240;attempt++)); do
    if grep -q "published as build/compiler" final-build.log; then
        break
    fi
    if grep -qE 'FAILED:|error:' final-build.log; then
        echo final-build-failed
        exit 2
    fi
    sleep 5
done
grep -q "published as build/compiler" final-build.log
cd final
export EXCLUSIVE_OWNER=codex-1383-struct
export EXCLUSIVE_TITLE="Recover direction 3 of 1383: final checker"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1383
"$HOME/buster-fast-bench/exclusive.sh" ./build/compiler test-checker --seed 133 > ../checker-final.log 2>&1
echo final-checker-status=0
