#!/bin/bash
# #877, second campaign: one hold's measurements, sqlite3.c's -c with the compile_time step's options, on CPU 2.
# Usage: v2-hold.sh stages|time ROUND
#   stages  measure-compile (11 runs with --time-stages and 11 without) of all 24 builds, the offsets in turn and the
#           three trees within each, starting a third further along each round. Round 1 first writes every build's
#           object: each must be main's at offset 0, byte for byte.
#   time    time-runs: main, B, C and main again (the floor), each over its eight offsets, two fresh copies each on
#           tmpfs, three runs in rotating order after a warm-up; each other build against main.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; V=$R/v2; L=$V/logs; O=$V/results
mode=$1 round=$2
head -1 /var/lib/buster-9700x/owner >> $L/holds.txt
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check --quiet || exit 1
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
offsets="0 16 32 48 1040 2080 3120 4032"
trees="main b c"
mkdir -p $O/out
case $mode in
stages)
    if [ $round = 1 ]; then
        for tree in $trees; do
            for n in $offsets; do
                taskset -c 2 $V/bin/$tree/compiler-$n "${options[@]}" -o $O/out/object-$tree-$n.o || echo "object-$tree-$n: FAILED"
            done
        done
        for f in $O/out/object-*.o; do
            if cmp -s $O/out/object-main-0.o $f; then echo "same $(basename $f)"; else echo "DIFFERS $(basename $f)"; fi
        done > $O/objects.txt
        sha256sum $O/out/object-*.o >> $O/objects.txt
    fi
    exes=()
    for n in $offsets; do for tree in $trees; do exes+=($V/bin/$tree/compiler-$n); done; done
    count=${#exes[@]}
    for ((p = 0; p < count; p++)); do
        t=$((((round - 1) * (count / 3) + p) % count))
        echo "== round $round tree ${exes[$t]} config [measure-compile --runs 11 -- ${options[*]}]"
        taskset -c 2 ${exes[$t]} measure-compile --runs 11 -- "${options[@]}"
    done
    ;;
time)
    builds=()
    for b in main:main b:b c:c main-again:main; do
        for n in $offsets; do builds+=(--build ${b%%:*} $V/bin/${b#*:}/compiler-$n); done
    done
    echo "== round $round"
    taskset -c 2 $R/bin/driver/compiler time-runs --runs 3 --copies 2 "${builds[@]}" --list "${options[@]}" -o $O/out/time.o
    echo "time-runs status $?"
    ;;
esac
