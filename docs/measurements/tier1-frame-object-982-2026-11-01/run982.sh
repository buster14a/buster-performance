#!/bin/bash
# speedtest1's --tier1 run time and instructions, bad4a76a (base) against
# 083a247e (head), on CPU 2 of the 9700X. #982's measurement.
set -u
export LC_ALL=C
m=$HOME/.cache/solve982-gentle/measure
RUNDIR=/tmp/solve982-gentle
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mkdir -p "$m/runs" "$m/counts" "$RUNDIR/db" "$RUNDIR/tmp"
run() { # build output
    local c=$1 out=$2 s e
    rm -rf "$RUNDIR/db"
    mkdir -p "$RUNDIR/db"
    TIMEFORMAT='%3U %3S'
    s=$EPOCHREALTIME
    { time (cd "$RUNDIR/db" && SQLITE_TMPDIR="$RUNDIR/tmp" taskset -c 2 "$m/st-$c" $OPTS speedtest1.db > "$out" 2>&1); } 2> "$out.time"
    e=$EPOCHREALTIME
    echo "$(( ${e/./} - ${s/./} )) $(cat "$out.time")"
}
builds=(t0-base t1-base t1s-base t0-head t1-head t1s-head)
for c in "${builds[@]}"; do
    run "$c" "$m/warmup-$c.txt" > /dev/null
done
: > "$m/run.times"
for r in $(seq 0 20); do
    for i in $(seq 0 5); do
        c=${builds[$(( (r + i) % 6 ))]}
        o=$m/runs/r$r-$c.txt
        echo "$r $c $(run "$c" "$o") $(awk '/TOTAL/ {print $2}' "$o")" >> "$m/run.times"
    done
done
for c in "${builds[@]}"; do
    vals=$(awk -v c="$c" '$2 == c {print $3}' "$m/run.times" | sort -n)
    med=$(echo "$vals" | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}')
    lo=$(echo "$vals" | head -1)
    hi=$(echo "$vals" | tail -1)
    umed=$(awk -v c="$c" '$2 == c {print $4}' "$m/run.times" | sort -n | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}')
    echo "$c: wall $med us ($lo-$hi), user $umed s (median of 21)"
done
# User-space instructions and cycles, five rounds in a rotating order.
: > "$m/counts.times"
for r in $(seq 0 4); do
    for c in t0-base t1-base t0-head t1-head; do
        rm -rf "$RUNDIR/db"
        mkdir -p "$RUNDIR/db"
        (cd "$RUNDIR/db" && SQLITE_TMPDIR="$RUNDIR/tmp" exec taskset -c 2 perf stat -x, -e instructions:u,cycles:u,task-clock -o "$m/counts/r$r-$c.stat" "$m/st-$c" $OPTS speedtest1.db > "$m/counts/r$r-$c.txt" 2>&1)
        echo "$r $c $(grep -E 'instructions|cycles' "$m/counts/r$r-$c.stat" | cut -d, -f1 | tr '\n' ' ')" >> "$m/counts.times"
    done
done
for c in t0-base t1-base t0-head t1-head; do
    imed=$(awk -v c="$c" '$2 == c {print $3}' "$m/counts.times" | sort -n | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}')
    cmed=$(awk -v c="$c" '$2 == c {print $4}' "$m/counts.times" | sort -n | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}')
    echo "$c: instructions $imed, cycles $cmed (median of 5)"
done
