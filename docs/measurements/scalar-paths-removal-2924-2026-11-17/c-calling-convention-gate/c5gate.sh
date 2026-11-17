#!/bin/bash
# #2924 C5, the calling convention's gate: benchmark-calling-convention by main's Release build (295417ae7; the module
# is unchanged through bd197b2a6), both paths interleaved, three processes, each under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the calling convention's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
C=../c4del/compilers/base
mkdir -p logs
sha256sum "$C" > logs/compiler.sha256
for round in 1 2 3; do
    $L timeout -k 5 900 taskset -c 2 "$C" benchmark-calling-convention > logs/bench-$round.log 2>&1
    echo "bench $round: $?" >> logs/status.txt
done
date -u +%FT%TZ > logs/.done
