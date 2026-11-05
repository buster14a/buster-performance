#!/usr/bin/env bash
# 1435 env sweep: closures.lua by main's (pre-#1433) and head's (#1433) Tier 1 Lua at shift 0, ASLR off (setarch -R),
# the environment one variable of 16 k bytes (k = 0 to 255), which moves the whole stack down by 16 k bytes over 4 KiB.
# perf stat's cycles, instructions, STLI and STLF, per run one hold, pinned to CPU 2, main and head alternating.
set -u
W=$HOME/buster-fast-bench/1435-claude
export EXCLUSIVE_OWNER=claude-1435 EXCLUSIVE_TITLE='Problem 1435' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1435
L=$HOME/buster-fast-bench/exclusive.sh
O=$W/envsweep
mkdir -p $O && cd $O || exit 1
E=cycles:u,instructions:u,ls_bad_status2.stli_other:u,ls_stlf:u
: > runs.txt
for k in $(seq 0 255); do
    v=$(head -c $((16 * k)) /dev/zero | tr '\0' x)
    order="main head"; [ $((k % 2)) = 1 ] && order="head main"
    for c in $order; do
        $L env -i PATH=/usr/bin:/bin "PADENV=$v" setarch -R taskset -c 2 perf stat -x, -e $E -o $O/one.txt $W/base/lua-$c-p0 $W/base/closures.lua > /dev/null 2>&1
        awk -F, -v c=$c -v k=$k 'BEGIN{ORS=""; print k, c} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $O/one.txt >> runs.txt
    done
done
echo done > done.txt
