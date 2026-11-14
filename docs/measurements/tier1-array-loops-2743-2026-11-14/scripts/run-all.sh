#!/usr/bin/env bash
# run-all.sh MARCH [CPU]: every kernel by every build, calibrated repetitions; one line per (build, kernel).
set -u
MARCH=$1
CPU=${2:-}
cd "$(dirname "$0")"
PIN=""
if [ -n "$CPU" ]; then PIN="taskset -c $CPU"; fi
for h in out/$MARCH/h-*; do
    name=${h##*/h-}
    for k in $(out/$MARCH/h-clang-O2 list); do
        line=$($PIN "$h" "$k" 0 2>&1) || line="$k FAILED $line"
        echo "$name $line"
    done
done
