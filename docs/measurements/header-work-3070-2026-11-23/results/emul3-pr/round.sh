#!/usr/bin/env bash
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
C=$1; out=$2; round=$3
export LC_ALL=C
work=/dev/shm/3070-claude-euler-emul2
events=cycles:u,cycles:k,instructions:u,instructions:k,page-faults,task-clock
{ uname -r; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host-$round.txt"
run() { # LABEL COMMAND...
    local label=$1; shift
    rm -rf "$work"; mkdir -p "$work"
    (cd "$work" && perf stat -x, -e "$events" -o "$out/perf-$label.$round.csv" -- taskset -c 2 "$@" > /dev/null 2> "$out/err-$label.$round.txt")
    echo "$label round $round status $? objects $(ls "$work" | wc -l)" >> "$out/status.txt"
}
order=(all defs kept red all-w defs-w kept-w red-w)
for ((k = 0; k < 8; k += 1)); do
    name=${order[$(( (k + round) % 8 ))]}
    dir=${name%-w}; w=(); [ "$name" != "$dir" ] && w=(-w)
    case $dir in all) units=("$D"/red2/all/*.c) ;; defs) units=("$D"/red2/defs/*.c) ;; kept) units=("$D"/red2/defsw/*.c) ;; red) units=("$D"/red/c/*.c) ;; esac
    run $name "$C" -c --lanes 1 -std=c99 -ffreestanding "${w[@]}" "${units[@]}"
done
