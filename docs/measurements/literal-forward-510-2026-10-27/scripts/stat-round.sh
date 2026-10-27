#!/usr/bin/env bash
# stat-round.sh ROUND [BINARY...]: -fsyntax-only of sqlite3.c by perf stat -r 15 (cycles, instructions, failed
# store-to-load forwards, mispredicted branches), pinned to CPU 2, for each tree's executable at each shift and the
# copy of the one at shift 0, in an order rotated by 5 per round. The lock is contended (about 10 minutes a hold on
# 2026-10-26), so only rounds 1 and 2 run, and the list the queue passes is ignored. Each run takes the lock alone.
set -u
here="$HOME/buster-fast-bench/literal-510"
cd "$here"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
round=$1
[ "$round" -le 2 ] || exit 0
binaries=()
for s in s0 s0-copy s16 s32 s48 s64 s1024; do binaries+=(main-$s head-$s); done
n=${#binaries[@]}
for ((k = 0; k < n; k += 1)); do
    b=${binaries[$(((k + (round - 1) * 5) % n))]}
    ./locked.sh taskset -c 2 perf stat -r 15 -x, -e cycles:u,instructions:u,ls_bad_status2.stli_other:u,ex_ret_brn_misp:u "$here/bin/$b" -fsyntax-only "${sqlite[@]}" \
        > /dev/null 2> results/stat-$b-$round.txt
done
