#!/bin/bash
# round490.sh R: round R of #490's A/B, run inside one hold of the shared lock (queue490.sh takes it): main (35f26f68
# with benchmark-link's fault counts and the diagnostic populate switch), the head, and main before
# libgcc.a (ff8936be, #483's archived build, "pre"), in an order that rotates by round. Each runs benchmark-link --only
# direct (every kind, its default programs: 1, 2,000 and 102,400 workers, its lane on CPU 2), main once more with its
# snapshot's mapping populated before use (BUSTER_SNAPSHOT_POPULATE), benchmark-snapshot --only dynamic and --only
# shared pinned to CPU 2, and the C driver compiling and linking a hello world by the direct path, 41 whole processes
# after 5 warm-ups (time-runs), pinned to CPU 2.
set -u
B=~/buster-fast-bench/perf-490-claude
r=$1
case $((r % 3)) in
    0) order="pre main head" ;;
    1) order="main head pre" ;;
    *) order="head pre main" ;;
esac
for t in $order; do
    if [ "$t" = pre ]; then
        compiler=~/buster-fast-bench/libgcc-136-main/build/compiler
    else
        compiler=$B/$t/build/compiler
    fi
    w=$B/work-$t
    mkdir -p "$w/tmp" "$w/cache" "$w/proc-cache" "$B/logs-$t"
    cd "$w" || exit 1
    "$compiler" benchmark-link --only direct --directory "$w/tmp" --cache "$w/cache" > "$B/logs-$t/link-$r.log" 2>&1
    echo "$t link $r: $?"
    if [ "$t" = main ]; then
        BUSTER_SNAPSHOT_POPULATE=1 "$compiler" benchmark-link --only direct --directory "$w/tmp" --cache "$w/cache" > "$B/logs-$t/link-populated-$r.log" 2>&1
        echo "$t link populated $r: $?"
    fi
    taskset -c 2 "$compiler" benchmark-snapshot --only dynamic --directory "$w/tmp" > "$B/logs-$t/snapshot-dynamic-$r.log" 2>&1
    echo "$t snapshot dynamic $r: $?"
    taskset -c 2 "$compiler" benchmark-snapshot --only shared --directory "$w/tmp" > "$B/logs-$t/snapshot-shared-$r.log" 2>&1
    echo "$t snapshot shared $r: $?"
    XDG_CACHE_HOME="$w/proc-cache" taskset -c 2 "$compiler" time-runs --runs 41 --warmups 5 --list "$B/hello.c" -o "$w/tmp/hello" > "$B/logs-$t/proc-$r.log" 2>&1
    echo "$t proc $r: $?"
done
