#!/usr/bin/env bash
# #543's review: benchmark-checker-source of the frozen sqlite3.c on main cb5736ff, #502's section and main again, each
# at the six placements of queue5.sh, from two fresh copies (paths of one length) per round, three rounds, the builds
# in an order that rotates by round. Address space randomization stays on, so each process gets its own stack offset
# (#445). Every process takes the lock alone, pinned to CPU 2.
set -u
here="$HOME/buster-fast-bench/checker-placement-502"
q="$here/q5"
cd "$q"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
shifts="0 688 1376 2064 2752 3440"
mkdir -p results/q6
copies=/tmp/c502-copies
builds=(main:main s502:s502 again:main)
for round in 1 2 3; do
    rm -rf $copies; mkdir -p $copies
    for b in "${builds[@]}"; do
        for s in $shifts; do
            for c in a b; do cp shifts/${b#*:}/compiler-$s $copies/$(printf '%-5s' ${b%%:*} | tr ' ' x)-$(printf '%04d' $s)-$c; done
        done
    done
    n=${#builds[@]}
    for ((k = 0; k < n; k += 1)); do
        b=${builds[$(((k + round - 1) % n))]}
        name=${b%%:*}
        for s in $shifts; do
            for c in a b; do
                exe=$copies/$(printf '%-5s' $name | tr ' ' x)-$(printf '%04d' $s)-$c
                "$here/locked.sh" taskset -c 2 "$exe" benchmark-checker-source "${source[@]}" > results/q6/$name-$s-$c-$round.txt 2>&1
            done
        done
    done
done
rm -rf $copies
echo done > results/q6/queue6.done
