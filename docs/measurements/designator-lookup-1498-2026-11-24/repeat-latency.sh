#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
. ./host.sh
# Capture the competing work at both boundaries inside the same hold as the latency run.
locked 180 bash -ec '
    snapshot() {
        cat /proc/loadavg
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -11
    }
    snapshot > raw/time-runs-repeat.before
    args=()
    while read -r shape fields rows group; do
        args+=(--list -std=c11 -c "input/$shape.c" -o "input/time-$shape.o")
    done < shapes.txt
    taskset -c 2 head/build/compiler time-runs --runs 24 --warmups 2 \
        --build base base/build/compiler --build head head/build/compiler "${args[@]}" > raw/time-runs-repeat.txt
    snapshot > raw/time-runs-repeat.after
'
