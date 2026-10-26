#!/usr/bin/env bash
root="$1"; shift
for spec in "$@"; do
    tree="${spec%%:*}"; variant="${spec#*:}"
    [ "$variant" = "$spec" ] && variant=""
    for path in scalar vector; do
        for runs in 10 30; do
            line=$(cd "$root/$tree" && env ${variant:+BUSTER_456_VARIANT=$variant} perf stat -x, -e instructions:u,cycles:u taskset -c 2 ./build/compiler benchmark-check-debug --only emit --path $path --runs $runs 2>&1 >/dev/null | grep -E "instructions|cycles" | cut -d, -f1 | tr '\n' ' ')
            echo "counts $spec $path $runs $line"
        done
    done
done
