#!/bin/bash
# #1373 leftovers: ROUNDS rounds, each one lock hold running every kernel binary once on CPU 2 in an order that rotates
# by round; each binary prints the best of its 5 inner repetitions of each loop. The busiest processes and the load
# average before and after each hold go to results/busy-ROUND.txt.
set -u
cd ~/buster-fast-bench/1373-claude-move
export EXCLUSIVE_OWNER=claude-1373-move EXCLUSIVE_TITLE="buster #1373 leftovers: inline memmove 33-128 and __builtin_copysign" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1373
ROUNDS=${ROUNDS:-5}
mkdir -p results
binaries=()
for tree in $TREES; do for t in t0 t1; do for m in x86-64 znver5; do binaries+=("$tree-$t-$m"); done; done; done
for o in O0 O2; do for m in x86-64 znver5; do binaries+=("clang-$o-$m"); done; done
n=${#binaries[@]}
for ((r = 0; r < ROUNDS; r++)); do
    order=()
    for ((k = 0; k < n; k++)); do order+=("${binaries[$(((k + r) % n))]}"); done
    ~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> results/holds.txt; { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > results/busy-'$r'.txt; for b in "$@"; do printf "%s\t%s\n" "$b" "$(taskset -c 2 timeout -k 5 120 ./bin/$b)"; done; { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> results/busy-'$r'.txt' _ "${order[@]}" > results/round-$r.txt 2> results/round-$r.err
    echo "round $r done"
done
echo done
