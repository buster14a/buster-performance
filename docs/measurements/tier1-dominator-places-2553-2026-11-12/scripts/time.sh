#!/usr/bin/env bash
# 2553 runtime (from #1216s record), step 3: the timed runs. Every executable prepare.sh checked runs once untimed (each script for Lua),
# then ROUNDS_LUA rounds of Lua (each layout, each script, base and head in turn, their order alternating by round,
# layout and script: the two-build Williams design) and ROUNDS_ST rounds of speedtest1 (each shift, the order
# alternating by round and shift), the programs' rounds interleaved. Each run is one hold of the lock, pinned to CPU 2,
# counted by perf stat (task-clock, user cycles and instructions); speedtest1's from a fresh database and temporary
# directory on tmpfs, made and removed outside its count. A line per run in OUT/runs.txt: program, layout (Lua's order,
# speedtest1's shift), round, revision, script, exit status and the counts.
set -u
W=$HOME/buster-fast-bench/2553-claude
export EXCLUSIVE_OWNER=claude-2553 EXCLUSIVE_TITLE="Tier 1: values keep their registers along dominators (#2553)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2553
L=$HOME/buster-fast-bench/exclusive.sh
REVS=${REVS:-base h7 h11}
I=$W/inputs
ROUNDS_LUA=${ROUNDS_LUA:-5}
ROUNDS_ST=${ROUNDS_ST:-7}
O=$W/${OUT:-runs}
scripts="calls tables strings arithmetic closures"
STOPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
E=task-clock,cycles:u,instructions:u
orders=$(awk '{print $1}' $W/orders.txt)
shifts=$(ls $W/exe | sed -n 's/^st-base-s//p' | sort -n)
mkdir -p $O && cd $O || exit 1
T=$(mktemp -d /tmp/claude2553.XXXXXX)
: > runs.txt
echo "$(date -u +%FT%TZ) start: rounds lua $ROUNDS_LUA st $ROUNDS_ST, orders $(echo $orders | wc -w), shifts $shifts" > log.txt
# The revisions in turn for a run's index: rotated by it, and reversed every other cycle, so that each revision takes
# each position equally often.
rotation() {
    local n=$(echo $REVS | wc -w) k=$1 list
    list=$(echo $REVS | tr ' ' '\n' | awk -v k=$(( $1 % n )) -v n=$n '{ a[NR - 1] = $0 } END { for (i = 0; i < n; i++) print a[(i + k) % n] }')
    if [ $(( ($1 / n) % 2 )) = 1 ]; then list=$(echo "$list" | tac); fi
    echo $list
}
record() {
    awk -F, -v head="$1" -v rc=$2 'BEGIN { ORS = ""; print head " status=" rc } /^[0-9]/ { n = $3; sub(/:u$/, "", n); print " " n "=" $1 } END { print "\n" }' $T/one.txt >> runs.txt
}
lua_run() {
    rm -f $T/one.txt
    $L bash -c "cd $I/lua && taskset -c 2 perf stat -x, -e $E -o $T/one.txt $W/exe/lua-$1-o$2 $3.lua > /dev/null 2>&1"
}
st_run() {
    rm -f $T/one.txt
    $L bash -c "d=\$(mktemp -d /dev/shm/st2553.XXXXXX) && mkdir \$d/db \$d/tmp && cd \$d/db && SQLITE_TMPDIR=\$d/tmp taskset -c 2 perf stat -x, -e $E -o $T/one.txt $W/exe/st-$1-s$2 $STOPTS speedtest1.db > /dev/null 2>&1; rc=\$?; rm -rf \$d; exit \$rc"
}
for o in $orders; do for t in $REVS; do for s in $scripts; do lua_run $t $o $s; done; done; done
for n in $shifts; do for t in $REVS; do st_run $t $n; done; done
echo "$(date -u +%FT%TZ) warm-ups done" >> log.txt
rounds=$(( ROUNDS_LUA > ROUNDS_ST ? ROUNDS_LUA : ROUNDS_ST ))
for r in $(seq 1 $rounds); do
    if [ $r -le $ROUNDS_LUA ]; then
        for o in $orders; do
            i=0
            for s in $scripts; do
                rot=$(rotation $(( r + o + i )))
                for t in $rot; do lua_run $t $o $s; record "lua $o $r $t $s" $?; done
                i=$((i + 1))
            done
        done
    fi
    if [ $r -le $ROUNDS_ST ]; then
        k=0
        for n in $shifts; do
            rot=$(rotation $(( r + k )))
            for t in $rot; do st_run $t $n; record "st $n $r $t st" $?; done
            k=$((k + 1))
        done
    fi
    echo "$(date -u +%FT%TZ) round $r done" >> log.txt
done
rm -rf $T
echo "$(date -u +%FT%TZ) done, $(grep -vc ' status=0 ' runs.txt) failed runs" >> log.txt
