#!/usr/bin/env bash
# rounds2.sh ROUNDS OUTDIR TREE...: like rounds.sh, over the given trees (the first the reference), into OUTDIR. Each round
# is one lock hold that runs every measurement on every tree, the trees in an order that rotates by round, each process
# pinned to CPU 2. Builds each tree without a build first, under a lock hold of its own, and checks that its object of
# sqlite3.c is the first tree's.
set -u
cd "$(dirname "$0")"
W=$PWD
rounds=$1 out=$2; shift 2
trees=("$@")
export EXCLUSIVE_OWNER=ld148-claude EXCLUSIVE_TITLE="#148 long double, __int128 and _BitInt builtins: main vs heads" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
L=~/buster-fast-bench/exclusive.sh
SQLITE=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
SUITE=$(ls ~/buster-fast-bench/claude-435/c-testsuite/tests/single-exec/*.c | tr '\n' ' ')
for t in "${trees[@]}"; do
    if [ ! -x $t/build/compiler ]; then
        ( cd $t && $L env BUSTER_DEBUG_INFO=0 ./build.sh ) > build-$t.log 2>&1 || { echo "build $t failed"; exit 1; }
    fi
    $t/build/compiler -c -o drive-$t.o $SQLITE || { echo "drive $t failed"; exit 1; }
    cmp -s drive-${trees[0]}.o drive-$t.o && echo "drive $t: identical to ${trees[0]}" || echo "drive $t: DIFFERS from ${trees[0]}"
done
mkdir -p $out
n=${#trees[@]}
for ((r = 0; r < rounds; r++)); do
    order=("${trees[@]:$((r % n))}" "${trees[@]:0:$((r % n))}")
    $L bash -c '
        for t in '"${order[*]}"'; do
            taskset -c 2 $t/build/compiler time-runs --runs 11 --list -c -o '"$W"'/ab.o '"$SQLITE"' > '"$out"'/'"$r"'-$t-driver.log 2>&1
            taskset -c 2 $t/build/compiler benchmark-lowering-source '"$SQLITE"' > '"$out"'/'"$r"'-$t-lowering-sqlite.log 2>&1
            taskset -c 2 $t/build/compiler benchmark-lowering-source '"$SUITE"' > '"$out"'/'"$r"'-$t-lowering-suite.log 2>&1
            taskset -c 2 $t/build/compiler benchmark-builtin-lowering > '"$out"'/'"$r"'-$t-builtin-lowering.log 2>&1
        done'
    echo "round $r done: ${order[*]}"
done
$L bash -c '
    for t in '"${trees[*]} ${trees[*]}"'; do
        echo "== $t"
        taskset -c 2 perf stat -r 11 -x, -e instructions:u,cycles:u $t/build/compiler -c -o '"$W"'/ab.o '"$SQLITE"' 2>&1 >/dev/null
    done' > $out/perfstat.log 2>&1
echo done
