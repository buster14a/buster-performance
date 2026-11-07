#!/bin/bash
# #877: one hold's measurements, both pairs (#1025: ebee03e2 against its merge 2ffcd901; #1067: d3086da6 against its
# merge 59a48a56), sqlite3.c's -c with the compile_time step's options, on CPU 2. run2.sh runs it under exclusive.sh.
# Usage: hold.sh stages|time ROUND
#   stages  measure-compile (11 runs with --time-stages and 11 without, rotating, after a warm-up of each) of all 32
#           builds, the offsets in turn and the four trees within each, starting a third further along each round.
#           Round 1 first writes every build's object: each must be its pair's base's at offset 0, byte for byte.
#   time    time-runs of each pair: base, merge and base again (the comparison's floor), each over its eight offsets,
#           three fresh copies each on tmpfs, three runs in rotating order after a warm-up; the pairs' order
#           alternates by round.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; L=$R/logs; O=$R/results
mode=$1 round=$2
head -1 /var/lib/buster-9700x/owner >> $L/holds.txt
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check --quiet || exit 1
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
offsets="0 16 32 48 1040 2080 3120 4032"
trees="ebee03e2 2ffcd901 d3086da6 59a48a56"
pairs=("ebee03e2 2ffcd901" "d3086da6 59a48a56")
mkdir -p $O/out
case $mode in
stages)
    if [ $round = 1 ]; then
        for tree in $trees; do
            for n in $offsets; do
                taskset -c 2 $R/bin/$tree/compiler-$n "${options[@]}" -o $O/out/object-$tree-$n.o || echo "object-$tree-$n: FAILED"
            done
        done
        for pair in "${pairs[@]}"; do
            set -- $pair
            for tree in $1 $2; do
                for n in $offsets; do
                    f=$O/out/object-$tree-$n.o
                    if cmp -s $O/out/object-$1-0.o $f; then echo "same $(basename $f)"; else echo "DIFFERS $(basename $f)"; fi
                done
            done
        done > $O/objects.txt
        sha256sum $O/out/object-*.o >> $O/objects.txt
    fi
    exes=()
    for n in $offsets; do for tree in $trees; do exes+=($R/bin/$tree/compiler-$n); done; done
    count=${#exes[@]}
    for ((p = 0; p < count; p++)); do
        t=$((((round - 1) * (count / 3) + p) % count))
        echo "== round $round tree ${exes[$t]} config [measure-compile --runs 11 -- ${options[*]}]"
        taskset -c 2 ${exes[$t]} measure-compile --runs 11 -- "${options[@]}"
    done
    ;;
time)
    order="0 1"
    [ $((round % 2)) = 0 ] && order="1 0"
    for i in $order; do
        set -- ${pairs[$i]}
        builds=()
        for b in base:$1 head:$2 base-again:$1; do
            for n in $offsets; do builds+=(--build ${b%%:*} $R/bin/${b#*:}/compiler-$n); done
        done
        echo "== round $round pair $1 $2"
        taskset -c 2 $R/bin/driver/compiler time-runs --runs 3 --copies 3 "${builds[@]}" --list "${options[@]}" -o $O/out/time.o
        echo "time-runs status $?"
    done
    ;;
esac
