#!/bin/bash
# A control for #136's jump tables on the 9700X, each run its own hold of the lock, pinned to CPU 2: -fsyntax-only of
# sqlite3.c, which never reaches the lowering (user instructions and cycles, perf stat -r 11), main's and the branch's
# in turn, two rounds. A difference there is the executables' placement, not the branch's work.
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
quiet() { grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:"; }
for round in 1 2; do
    for d in backend-136-main jump-136-claude; do
        cd $B/$d || exit 1
        $X taskset -c 2 perf stat -r 11 -x, -e instructions:u,cycles:u ./build/compiler -fsyntax-only -I$Q $Q/sqlite3.c > jt-syntax-$round.log 2>&1
        echo "== $d -fsyntax-only perf round $round: $?"; quiet < jt-syntax-$round.log | grep -E 'instructions|cycles'
    done
done
echo done
