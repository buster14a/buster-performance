#!/usr/bin/env bash
# 1435 link orders: Lua's 33 objects linked in ORDERS random orders (the same order for every build; order 0 is the
# usual one), main's (pre-#1433), pad0's (#1433), pad8's and pad0w's objects; closures.lua timed, ROUNDS rounds, the
# builds' order rotating by round, each run one hold, pinned to CPU 2. Placement moves whole objects against each other,
# which shifts of under 128 bytes don't.
set -u
W=$HOME/buster-fast-bench/1435-claude
export EXCLUSIVE_OWNER=claude-1435 EXCLUSIVE_TITLE='Problem 1435' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1435
L=$HOME/buster-fast-bench/exclusive.sh
ORDERS=${ORDERS:-8}
ROUNDS=${ROUNDS:-7}
BUILDS=${BUILDS:-main pad0 pad8 pad0w}
O=$W/orders${TAG:-}
mkdir -p $O && cd $O || exit 1
files="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
dir() { case $1 in main) echo $W/base/obj-main ;; *) echo $W/pad/obj-$1 ;; esac; }
for o in $(seq 0 $((ORDERS - 1))); do
    if [ $o = 0 ]; then perm="$files"; else perm=$(echo $files | tr ' ' '\n' | shuf --random-source=<(yes $o) | tr '\n' ' '); fi
    echo "$o $perm" >> orders.txt
    for b in $BUILDS; do
        objs=""; for f in $perm; do objs="$objs $(dir $b)/$f.o"; done
        $L bash -c "cd $O && cc -o lua-$b-o$o $objs -lm -ldl"
    done
done
E=task-clock,cycles:u,instructions:u
: > runs.txt
set -- $BUILDS
nb=$#
for round in $(seq 1 $ROUNDS); do
    for o in $(seq 0 $((ORDERS - 1))); do
        r=$(( (round + o) % nb ))
        rot=$(echo $BUILDS | awk -v r=$r '{ for (i = 0; i < NF; i++) printf "%s ", $(((i + r) % NF) + 1) }')
        for c in $rot; do
            $L taskset -c 2 perf stat -x, -e $E -o $O/one.txt $O/lua-$c-o$o $W/base/closures.lua > /dev/null 2>&1
            awk -F, -v c=$c -v r=$round -v p=$o 'BEGIN{ORS=""; print p, r, c} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $O/one.txt >> runs.txt
        done
    done
done
echo done > done.txt
