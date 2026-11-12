#!/usr/bin/env bash
# After compile1217.sh: speedtest1's base/head comparison again with its database and SQLite's temporary files in /tmp
# (tmpfs), as the 9700X job's measure-tier1-programs step keeps them (run1217.sh kept them on the nearly full /home,
# where speedtest1's journal syncs dominate its wall time), ROUNDS rounds, the builds' order alternating, each run one
# hold of the lock, pinned to CPU 2; then measure-tier1-programs by the head with --directory /tmp.
set -u
W=$HOME/buster-fast-bench/1217-claude
export EXCLUSIVE_OWNER=claude-1217 EXCLUSIVE_TITLE='Issue 1217: Tier 1 address arithmetic' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndCyWpFg1feNbcGfjY
L=$HOME/buster-fast-bench/exclusive.sh
ROUNDS=${ROUNDS:-11}
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
IN=$W/inputs
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
T=/tmp/claude-1217-st
log() { echo "$(date -u +%FT%TZ) $*" >> $W/rerun.log; }
cd $W || exit 1
echo $$ > rerun.pid
while [ -e compile.pid ] && kill -0 $(cat compile.pid) 2> /dev/null; do sleep 20; done
E=task-clock,cycles:u,instructions:u
: > $W/st-tmp-runs.txt
for round in 0 $(seq 1 $ROUNDS); do
    first=base; second=head
    [ $((round % 2)) = 1 ] && first=head && second=base
    for t in $first $second; do
        $L bash -c "rm -rf $T; mkdir -p $T/db $T/tmp; cd $T/db && SQLITE_TMPDIR=$T/tmp taskset -c 2 perf stat -x, -e $E -o $W/one-st.txt $W/st-$t $OPTS speedtest1.db > /dev/null 2>&1; rm -rf $T"
        awk -F, -v r=$round -v t=$t 'BEGIN{ORS=""; print (r == 0 ? "warmup" : "st"), r, 0, t, "speedtest1"} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $W/one-st.txt >> $W/st-tmp-runs.txt
    done
done
log "speedtest1 in /tmp done"
$L bash -c "unset CPATH C_INCLUDE_PATH; cd $W && clang --version | head -1 && taskset -c 2 $W/head/build/compiler measure-tier1-programs --runs 11 --clang clang --sqlite $SQ --speedtest $IN --lua $IN/lua-5.4.8/src --scripts $IN --directory /tmp" > $W/measure-tier1-programs-tmp.log 2>&1
log "measure-tier1-programs in /tmp exit $?"
log done
