#!/usr/bin/env bash
set -u
out=$1 round=$2 work=$3; shift 3
. "$out/vars.sh"
{ uname -r; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host-$round.txt"
n=${#builds[@]}
for ((k = 0; k < n; k += 1)); do
    i=$(( (k + round) % n )); b=${builds[$i]}; name=${b%%=*}; C=${b#*=}
    for kind in empty musl; do
        rm -rf "$work/o"; mkdir -p "$work/o"
        (cd "$work/o" && perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$out/perf-$kind-$name.$round.csv" -- taskset -c 2 bash "$out/loop.sh" "$C" $kind)
        echo "$kind $name round $round status $?" >> "$out/status.txt"
        (cd "$work/o" && cat *.o | sha256sum | cut -c1-16) > "$out/sum-$kind-$name.$round.txt" 2>&1
    done
done
