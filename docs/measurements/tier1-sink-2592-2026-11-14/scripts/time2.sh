#!/usr/bin/env bash
# 2592 runtime, step 3: the timed runs, by round.sh, a hold of the lock per program's round (Lua's about 20 s, every
# order, script and revision; speedtest1's about 8 s), the programs' rounds interleaved: first one untimed round of
# each, then ROUNDS_LUA of Lua and ROUNDS_ST of speedtest1. The 9700X's queue was ten deep with other sessions'
# builds, so #2553's hold per run would have waited hours; within a hold the runs are #2553's, in its order.
set -u
W=$HOME/buster-fast-bench/2592-claude
export EXCLUSIVE_OWNER=claude-2592 EXCLUSIVE_TITLE="Tier 1: dispatch tails without the r11 rotation (#2592)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2592
L=$HOME/buster-fast-bench/exclusive.sh
ROUNDS_LUA=${ROUNDS_LUA:-5}
ROUNDS_ST=${ROUNDS_ST:-7}
O=$W/runs
mkdir -p $O && cd $W || exit 1
: > $O/runs.txt
: > $O/busy.txt
echo "$(date -u +%FT%TZ) start: rounds lua $ROUNDS_LUA st $ROUNDS_ST, orders $(wc -l < orders.txt), shifts $(ls exe | sed -n 's/^st-base-s//p' | sort -n | tr '\n' ' ')" > $O/log.txt
$L ./round.sh warm lua 0 2>> $O/lock.txt
$L ./round.sh warm st 0 2>> $O/lock.txt
echo "$(date -u +%FT%TZ) warm-ups done" >> $O/log.txt
rounds=$(( ROUNDS_LUA > ROUNDS_ST ? ROUNDS_LUA : ROUNDS_ST ))
for r in $(seq 1 $rounds); do
    [ $r -le $ROUNDS_LUA ] && $L ./round.sh time lua $r 2>> $O/lock.txt
    [ $r -le $ROUNDS_ST ] && $L ./round.sh time st $r 2>> $O/lock.txt
    echo "$(date -u +%FT%TZ) round $r done" >> $O/log.txt
done
echo "$(date -u +%FT%TZ) done, $(grep -vc ' status=0 ' $O/runs.txt) failed runs of $(wc -l < $O/runs.txt)" >> $O/log.txt
