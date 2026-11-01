#!/usr/bin/env bash
# times.sh ROUNDS BUILD...: speedtest1's builds in st-*/ (as run.sh made them, named TREE/NAME), each run one hold of
# the shared lock, pinned to CPU 2, rounds of every build in an order that rotates by round; then each build's median
# wall time, and perf's user instructions and cycles of one run each.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-178-remat || exit 1
rounds=$1
shift
builds=("$@")
export EXCLUSIVE_OWNER=claude-178-remat
export EXCLUSIVE_TITLE="Tier 1 rematerialization in linear scan (#178): speedtest1's run times"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/178
lock=~/buster-fast-bench/exclusive.sh
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
RUNDIR=/tmp/claude-178-st
out=$PWD/times-$(date +%Y%m%dT%H%M%S)
mkdir -p $out $RUNDIR
run() { # tree/name output [options...]
    rm -rf $RUNDIR/run
    mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp
    local s e
    TIMEFORMAT='%3U %3S'
    s=$EPOCHREALTIME
    { time (cd $RUNDIR/run/db && SQLITE_TMPDIR=$RUNDIR/run/tmp taskset -c 2 $HOME/buster-fast-bench/claude-178-remat/st-${1%%/*}/st-${1##*/} $OPTS "${@:3}" speedtest1.db > $2 2>&1) ; } 2> $2.time
    e=$EPOCHREALTIME
    echo "$(( ${e/./} - ${s/./} )) $(cat $2.time)"
}
export -f run
export RUNDIR OPTS
for b in "${builds[@]}"; do
    "$lock" bash -c "run $b $out/verify-${b//\//-}.txt --verify > /dev/null"
    echo "$b $(grep -h 'Verification Hash' $out/verify-${b//\//-}.txt)"
done
: > $out/run.times
for r in $(seq 0 $((rounds - 1))); do
    for i in $(seq 0 $(( ${#builds[@]} - 1 ))); do
        b=${builds[$(( (r + i) % ${#builds[@]} ))]}
        line=$("$lock" bash -c "run $b $out/r$r-${b//\//-}.txt")
        echo "$r $b $line" >> $out/run.times
    done
done
for b in "${builds[@]}"; do
    awk -v b=$b '$2 == b {print $3}' $out/run.times | sort -n | awk -v b=$b '{a[NR]=$1} END {printf "%s median %d us (%d-%d) of %d\n", b, a[int((NR+1)/2)], a[1], a[NR], NR}'
done
for b in "${builds[@]}"; do
    "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=../tmp perf stat -x, -e instructions:u,cycles:u -o $out/stat-${b//\//-}.txt -- taskset -c 2 $HOME/buster-fast-bench/claude-178-remat/st-${b%%/*}/st-${b##*/} $OPTS speedtest1.db > /dev/null 2>&1"
    echo "$b: $(grep -v '^#' $out/stat-${b//\//-}.txt | cut -d, -f1,3 | tr '\n' ' ')"
done
echo "results in $out"
