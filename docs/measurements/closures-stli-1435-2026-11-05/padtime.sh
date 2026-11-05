#!/usr/bin/env bash
# 1435 pad timing: closures.lua by main's (pre-#1433) Tier 1 Lua, head's (#1433, pad 0) and head with every calling
# frame's objects 8, 16 and 32 bytes up (BUSTER_EXPERIMENT_FRAME_PAD), at code shifts given (default 0 32 96); ROUNDS
# rounds (default 11), the builds' order rotating by round, each run one hold, pinned to CPU 2. perf stat's task-clock,
# cycles, instructions, STLI.
set -u
W=$HOME/buster-fast-bench/1435-claude
export EXCLUSIVE_OWNER=claude-1435 EXCLUSIVE_TITLE='Problem 1435' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1435
L=$HOME/buster-fast-bench/exclusive.sh
O=$W/padtime${TAG:-}
SHIFTS=${SHIFTS:-0 32 96}
ROUNDS=${ROUNDS:-11}
BUILDS=${BUILDS:-main pad0 pad8 pad16 pad32}
mkdir -p $O && cd $O || exit 1
exe() { case $1 in main) echo $W/base/lua-main-p$2 ;; *) echo $W/pad/lua-$1-p$2 ;; esac; }
E=task-clock,cycles:u,instructions:u,ls_bad_status2.stli_other:u
: > runs.txt
set -- $BUILDS
nb=$#
for round in $(seq 1 $ROUNDS); do
    for n in $SHIFTS; do
        set -- $BUILDS
        r=$(( (round + n / 16) % nb ))
        order=""; i=0
        for b in $BUILDS; do order="$order $b"; done
        rot=$(echo $order | awk -v r=$r '{ for (i = 0; i < NF; i++) printf "%s ", $(((i + r) % NF) + 1) }')
        for c in $rot; do
            $L taskset -c 2 perf stat -x, -e $E -o $O/one.txt $(exe $c $n) $W/base/closures.lua > /dev/null 2>&1
            awk -F, -v c=$c -v r=$round -v p=$n 'BEGIN{ORS=""; print p, r, c} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $O/one.txt >> runs.txt
        done
    done
done
echo done > done.txt
