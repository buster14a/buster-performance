#!/usr/bin/env bash
# 2774: counters for arithmetic.lua and strings.lua, order 0, base and head, 5 runs each alternating, CPU 2.
W=$HOME/buster-fast-bench/2774-claude
cd $W/inputs/lua || exit 1
for s in arithmetic strings; do
  for k in 1 2 3 4 5; do
    for t in base head; do
      taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,branches:u,ex_ret_brn_ind_misp:u,de_no_dispatch_per_slot.no_ops_from_frontend:u -o /tmp/ctr2774.txt $W/exe/lua-$t-o0 $s.lua > /dev/null 2>&1
      echo "$s $t $k $(awk -F, '/^[0-9]/ {printf "%s=%s ", $3, $1}' /tmp/ctr2774.txt)"
    done
  done
done
