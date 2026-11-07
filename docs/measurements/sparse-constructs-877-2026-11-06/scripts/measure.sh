#!/bin/bash
# #877's matched comparison: sqlite3.c's -c with the compile_time step's options, each pull request's base against its
# merge, on CPU 2. Usage: measure.sh objects|stages|time 1025|1067
#   objects  every build's object, all in one hold of the lock; each must be the pair's base's at offset 0, byte for byte.
#   stages   measure-compile (11 runs with --time-stages and 11 without, rotating) of each build at each offset, the
#            base's and the merge's alternating, in three rounds whose order rotates as ab's do; each round one hold of
#            the lock (about a minute: under contention, a hold per executable waited minutes each), its output in ab's
#            format (stages-round, which measure.sh runs under the lock).
#   time     time-runs: base, merge and base again (the comparison's floor), each over its eight offsets, from three
#            fresh copies on tmpfs, three runs a round in rotating order; five rounds (ab), each its own hold.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; L=$R/logs; O=$R/results
case $2 in
    1025) base=ebee03e2 head=2ffcd901 ;;
    1067) base=d3086da6 head=59a48a56 ;;
    *) echo "usage: measure.sh objects|stages|time 1025|1067" >&2; exit 2 ;;
esac
export EXCLUSIVE_OWNER=claude-877 EXCLUSIVE_TITLE="#877 matched 9700X comparison of #1025 and #1067" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/877
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check --quiet || exit 1
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
offsets="0 16 32 48 1040 2080 3120 4032"
driver=$R/bin/driver/compiler
mkdir -p $O/out
case $1 in
objects)
    ~/buster-fast-bench/exclusive.sh bash -c '
        R=$1 O=$2 pair=$3 base=$4 head=$5; shift 5
        head -1 /var/lib/buster-9700x/owner >> $R/logs/holds.txt
        for tree in $base $head; do
            for n in 0 16 32 48 1040 2080 3120 4032; do
                taskset -c 2 $R/bin/$tree/compiler-$n "$@" -o $O/out/object-$pair-$tree-$n.o || echo "object-$pair-$tree-$n: FAILED"
            done
        done' objects $R $O $2 $base $head "${options[@]}" > $L/objects-$2.log 2>&1
    for f in $O/out/object-$2-*.o; do
        cmp -s $O/out/object-$2-$base-0.o $f && echo "same $(basename $f)" || echo "DIFFERS $(basename $f)"
    done > $O/objects-$2.txt
    sha256sum $O/out/object-$2-*.o >> $O/objects-$2.txt
    ;;
stages)
    : > $O/stages-$2.txt
    for round in 1 2 3; do
        ~/buster-fast-bench/exclusive.sh $R/measure.sh stages-round $2 $round >> $O/stages-$2.txt 2>&1
    done
    ;;
stages-round)
    head -1 /var/lib/buster-9700x/owner >> $L/holds.txt
    exes=()
    for n in $offsets; do exes+=($R/bin/$base/compiler-$n $R/bin/$head/compiler-$n); done
    count=${#exes[@]}
    for ((p = 0; p < count; p++)); do
        t=$(((${3} - 1 + p) % count))
        echo "== round $3 tree ${exes[$t]} config [measure-compile --runs 11 -- ${options[*]}]"
        taskset -c 2 ${exes[$t]} measure-compile --runs 11 -- "${options[@]}"
    done
    exit 0
    ;;
time)
    builds=()
    for b in base:$base head:$head base-again:$base; do
        for n in $offsets; do builds+=(--build ${b%%:*} $R/bin/${b#*:}/compiler-$n); done
    done
    $driver ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh $driver -- time-runs --runs 3 --copies 3 "${builds[@]}" --list "${options[@]}" -o $O/out/time-$2.o > $O/time-$2.txt 2>&1
    ;;
esac
echo "$(date -u +%FT%TZ) measure $1 $2 status $?" >> $L/receipts.txt
