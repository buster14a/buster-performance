#!/bin/bash
# probe1.sh SUFFIX: on Lua, main's and p2's tight sets with 11 and 101 passes, p2 with and without --fused and
# --interleave, three times each in one hold; files results/LABEL/probe-TAG-lua<suffix>-N.txt.
set -u
cd "$(dirname "$0")"
suffix=$1
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-probe$suffix.txt"
for n in 1 2 3; do
    for spec in "m5 p11 --passes 11" "p2 p11 --passes 11" "p2 p11f --passes 11 --fused" "p2 p11fi --passes 11 --fused --interleave 1" "m5 p101 --passes 101" "p2 p101 --passes 101" "p2 p101f --passes 101 --fused"; do
        set -- $spec
        label=$1; tag=$2; shift 2
        f=$PWD/results/$label/probe-$tag-lua$suffix-$n.txt
        commands="$commands; taskset -c 2 $PWD/results/$label/compiler measure-node-machine --shadow $* $lua/*.c 2>&1 | grep -E 'time sweeps|interleaved' > $f"
    done
done
./lock.sh bash -c "$commands"
