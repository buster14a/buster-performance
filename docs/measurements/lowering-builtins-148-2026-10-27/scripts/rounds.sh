#!/usr/bin/env bash
# rounds.sh ROUNDS: #148's long double builtins, main e04462c1 (twice: main and main2, the same executable) against the
# branch head, on the 9700X. Each round is one lock hold (about 40 s) that runs every measurement on every tree, the
# trees in an order that rotates by round, each process pinned to CPU 2.
set -u
cd "$(dirname "$0")"
W=$PWD
export EXCLUSIVE_OWNER=ld148-claude EXCLUSIVE_TITLE="#148 long double and __int128 builtins: main vs head" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
L=~/buster-fast-bench/exclusive.sh
SQLITE=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
SUITE=$(ls ~/buster-fast-bench/claude-435/c-testsuite/tests/single-exec/*.c | tr '\n' ' ')
trees=(main head main2)
mkdir -p rounds
for ((r = 0; r < $1; r++)); do
    order=("${trees[@]:$((r % 3))}" "${trees[@]:0:$((r % 3))}")
    $L bash -c '
        for t in '"${order[*]}"'; do
            taskset -c 2 $t/build/compiler time-runs --runs 11 --list -c -o '"$W"'/ab.o '"$SQLITE"' > rounds/'"$r"'-$t-driver.log 2>&1
            taskset -c 2 $t/build/compiler benchmark-lowering-source '"$SQLITE"' > rounds/'"$r"'-$t-lowering-sqlite.log 2>&1
            taskset -c 2 $t/build/compiler benchmark-lowering-source '"$SUITE"' > rounds/'"$r"'-$t-lowering-suite.log 2>&1
            taskset -c 2 $t/build/compiler benchmark-builtin-lowering > rounds/'"$r"'-$t-builtin-lowering.log 2>&1
        done'
    echo "round $r done: ${order[*]}"
done
echo done
