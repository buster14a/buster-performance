#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
side=$1
shape=$2
round=$3
stem="raw/$shape-$round-$side"
snapshot() {
    cat /proc/loadavg
    ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -11 || true
}
snapshot > "$stem.before"
taskset -c 2 perf stat --no-big-num -x ';' -r 3 -o "$stem.perf" \
    -e duration_time,task-clock,cycles:u,instructions:u,branches:u,branch-misses:u -- \
    "$side/build/compiler" -std=c11 -c "input/$shape.c" -o "input/$side-$shape.o"
snapshot > "$stem.after"
