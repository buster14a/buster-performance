#!/bin/bash
# #136's jump tables on one executable, on the 9700X: the branch's head with a measurement switch
# (BUSTER_NO_JUMP_TABLES, which leaves the lowering's tables' room at 0), so that tables on and off share the code's
# placement. Each perf stat its own hold of the lock, pinned to CPU 2: sqlite3.c's -c, off and on in turn, two rounds;
# then each mode's object against main's and the measured branch's.
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
D=$B/jump-136-toggle
quiet() { grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:"; }
cd $D || exit 1
for round in 1 2; do
    for mode in off on; do
        if [ $mode = off ]; then e="env BUSTER_NO_JUMP_TABLES=1"; else e="env -u BUSTER_NO_JUMP_TABLES"; fi
        $X taskset -c 2 $e perf stat -r 11 -x, -e instructions:u,cycles:u ./build/compiler -c -I$Q -o $D/sqlite3-$mode.o $Q/sqlite3.c > toggle-$mode-$round.log 2>&1
        echo "== tables $mode, round $round: $?"; quiet < toggle-$mode-$round.log | grep -E 'instructions|cycles'
    done
done
cmp $D/sqlite3-off.o $B/backend-136-main/sqlite3.o && echo "tables off: main's object, byte for byte"
cmp $D/sqlite3-on.o $B/jump-136-claude/sqlite3.o && echo "tables on: the measured branch's object, byte for byte"
echo done
