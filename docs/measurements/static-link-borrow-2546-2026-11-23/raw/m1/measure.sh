#!/bin/sh
# measure.sh RUNS BIN... : fresh-process static hello world builds, interleaved, perf stat each, CPU 2.
# Each binary gets its own cache directory (its own snapshot), warmed by one build first.
set -u
runs=$1; shift
dir=$(cd "$(dirname "$0")" && pwd)
out=$dir/results; mkdir -p "$out"
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
for b in "$@"; do
    n=$(basename "$b"); mkdir -p "$CACHE_ROOT/cache-$n" "$dir/out-$n"
    XDG_CACHE_HOME=$CACHE_ROOT/cache-$n taskset -c 2 "$b" -static "$dir/hello.c" -o "$dir/out-$n/hello" || echo "warm failed $n"
    "$dir/out-$n/hello"; sha256sum "$dir/out-$n/hello"
done
for i in $(seq "$runs"); do
    for b in "$@"; do
        n=$(basename "$b")
        XDG_CACHE_HOME=$CACHE_ROOT/cache-$n perf stat -x, -e task-clock,cycles:u,cycles:k,instructions:u,page-faults -o "$out/$n.$i.perf" \
            taskset -c 2 "$b" -static "$dir/hello.c" -o "$dir/out-$n/hello"
        XDG_CACHE_HOME=$CACHE_ROOT/cache-$n taskset -c 2 "$b" -static --time-stages "$dir/hello.c" -o "$dir/out-$n/hello" 2> "$out/$n.$i.ts"
    done
done
for b in "$@"; do sha256sum "$dir/out-$(basename "$b")/hello"; done
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
