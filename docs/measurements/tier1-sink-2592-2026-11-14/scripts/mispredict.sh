#!/usr/bin/env bash
# mispredict.sh: closures.lua and strings.lua by every order's base and head executable once, pinned to CPU 2, with
# their user cycles, instructions, branch mispredictions and branches (perf stat), under one hold of the lock (~10 s),
# to see whether the scripts' layout-dependent cycles follow the mispredictions.
set -u
W=$HOME/buster-fast-bench/2592-claude
cd $W/inputs/lua || exit 1
for s in closures strings; do
    for o in $(awk '{print $1}' $W/orders.txt); do
        for t in base head; do
            perf stat -x, -e cycles:u,instructions:u,branch-misses:u,branches:u -o /tmp/claude2592-m.txt taskset -c 2 $W/exe/lua-$t-o$o $s.lua > /dev/null 2>&1
            echo "$s $o $t $(awk -F, '/^[0-9]/ { n = $3; sub(/:u$/, "", n); printf "%s=%s ", n, $1 }' /tmp/claude2592-m.txt)"
        done
    done
done
rm -f /tmp/claude2592-m.txt
