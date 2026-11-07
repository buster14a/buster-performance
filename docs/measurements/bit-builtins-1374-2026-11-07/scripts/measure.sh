#!/bin/bash
# #1374: ROUNDS rounds, each one lock hold running every kernel binary once on CPU 2 in an order that rotates by round;
# each binary prints the best of its 5 inner repetitions of each loop (20 M calls), timed inside the hold.
set -u
cd ~/buster-fast-bench/1374-opencode
export EXCLUSIVE_OWNER=opencode-1374 EXCLUSIVE_TITLE="opencode #1374 bit builtins A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1374
ROUNDS=${ROUNDS:-7}
mkdir -p results
binaries=($(cd bin && ls | grep -v '\.' | sort))
n=${#binaries[@]}
for ((r = 0; r < ROUNDS; r++)); do
    order=()
    for ((k = 0; k < n; k++)); do order+=("${binaries[$(((k + r) % n))]}"); done
    ~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> results/holds.txt; for b in "$@"; do printf "%s\t%s\n" "$b" "$(taskset -c 2 ./bin/$b)"; done' _ "${order[@]}" > results/round-$r.txt 2> results/round-$r.err
    echo "round $r done"
done
echo done
