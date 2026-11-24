#!/usr/bin/env bash
set -u
out=$1 round=$2 work=$3 events=$4; shift 4
. "$out/vars.sh"
{ uname -r; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host-$round.txt"
run() { # LABEL BUILD CPUS COMMAND...
    local label=$1 build=$2 cpus=$3; shift 3
    rm -rf "$work/o"; mkdir -p "$work/o"
    (cd "$work/o" && perf stat -x, -e "$events" -o "$out/perf-$label-$build.$round.csv" -- taskset -c "$cpus" "$@" > /dev/null 2> "$out/err-$label-$build.$round.txt")
    echo "$label $build round $round status $?" >> "$out/status.txt"
    (cd "$work/o" && cat *.o | sha256sum | cut -c1-16) > "$out/sum-$label-$build.$round.txt" 2>&1
}
n=${#builds[@]}
for ((k = 0; k < n; k += 1)); do
    i=$(( (k + round) % n )); b=${builds[$i]}; name=${b%%=*}; rest=${b#*=}
    IFS=, read -r -a parts <<< "$rest"; C=${parts[0]}; extra=("${parts[@]:1}")
    run empty $name 2 "$C" -c --lanes 1 "${extra[@]}" "${opts[@]}" "$D"/empty/*.c
    run musl1 $name 2 "$C" -c --lanes 1 "${extra[@]}" "${opts[@]}" "${units[@]}"
    run musl4 $name 2,3,4,5 "$C" -c --lanes 4 "${extra[@]}" "${opts[@]}" "${units[@]}"
    run lua1 $name 2 "$C" -c --lanes 1 "${extra[@]}" "${luaopts[@]}" "${lua[@]}"
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host-$round.txt"
