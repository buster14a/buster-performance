#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
label=$1
iterations=$2
{
  date -u -Iseconds
  cat /proc/loadavg
  ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -7 || true
} >> activity.log
LC_ALL=C taskset -c 2 perf stat --no-big-num -x ';' -e cycles:u,instructions:u,branches:u,branch-misses:u,task-clock -o "$label.stat.new" -- "./programs/${label#*-}" "$iterations" > "$label.stdout.new"
scale=${label#*-}; scale=${scale#*-}; scale=${scale%%-*}
cmp "expected-$scale.txt" "$label.stdout.new"
mv "$label.stdout.new" "$label.stdout"
mv "$label.stat.new" "$label.stat"
{
  date -u -Iseconds
  cat /proc/loadavg
  ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -7 || true
} >> activity.log
