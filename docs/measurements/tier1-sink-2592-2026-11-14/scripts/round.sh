#!/usr/bin/env bash
# round.sh MODE PROGRAM ROUND, run under one hold of the lock by time2.sh: every run of PROGRAM's round (lua: each
# order, script and revision; st: each shift and revision), as #2553's time.sh orders them: the revisions in turn,
# rotated by round, layout and script and reversed every other cycle (the two-build Williams design). MODE warm runs
# each once without recording; MODE time appends a line per run to runs/runs.txt. Each run is pinned to CPU 2 and
# counted by perf stat (task-clock, user cycles and instructions); speedtest1's from a fresh database and temporary
# directory on tmpfs, made and removed outside its count. The busiest processes and the load average go to
# runs/busy.txt at the hold's start and end.
set -u
W=$HOME/buster-fast-bench/2592-claude
REVS=${REVS:-base head}
I=$W/inputs
O=$W/runs
mode=$1; program=$2; r=$3
scripts="calls tables strings arithmetic closures"
STOPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
E=task-clock,cycles:u,instructions:u
orders=$(awk '{print $1}' $W/orders.txt)
shifts=$(ls $W/exe | sed -n 's/^st-base-s//p' | sort -n)
T=$(mktemp -d /tmp/claude2592.XXXXXX)
busy() { { echo "$(date -u +%FT%TZ) $mode $program $r $1: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> $O/busy.txt; }
rotation() {
    local n=$(echo $REVS | wc -w) list
    list=$(echo $REVS | tr ' ' '\n' | awk -v k=$(( $1 % n )) -v n=$n '{ a[NR - 1] = $0 } END { for (i = 0; i < n; i++) print a[(i + k) % n] }')
    if [ $(( ($1 / n) % 2 )) = 1 ]; then list=$(echo "$list" | tac); fi
    echo $list
}
record() {
    [ $mode = time ] && awk -F, -v head="$1" -v rc=$2 'BEGIN { ORS = ""; print head " status=" rc } /^[0-9]/ { n = $3; sub(/:u$/, "", n); print " " n "=" $1 } END { print "\n" }' $T/one.txt >> $O/runs.txt
}
lua_run() {
    rm -f $T/one.txt
    (cd $I/lua && taskset -c 2 perf stat -x, -e $E -o $T/one.txt $W/exe/lua-$1-o$2 $3.lua > /dev/null 2>&1)
}
st_run() {
    rm -f $T/one.txt
    local d rc
    d=$(mktemp -d /dev/shm/st2592.XXXXXX) && mkdir $d/db $d/tmp
    (cd $d/db && SQLITE_TMPDIR=$d/tmp taskset -c 2 perf stat -x, -e $E -o $T/one.txt $W/exe/st-$1-s$2 $STOPTS speedtest1.db > /dev/null 2>&1)
    rc=$?
    rm -rf $d
    return $rc
}
busy start
if [ $program = lua ]; then
    for o in $orders; do
        i=0
        for s in $scripts; do
            rot=$(rotation $(( r + o + i )))
            for t in $rot; do lua_run $t $o $s; record "lua $o $r $t $s" $?; done
            i=$((i + 1))
        done
    done
else
    k=0
    for n in $shifts; do
        rot=$(rotation $(( r + k )))
        for t in $rot; do st_run $t $n; record "st $n $r $t st" $?; done
        k=$((k + 1))
    done
fi
busy end
rm -rf $T
