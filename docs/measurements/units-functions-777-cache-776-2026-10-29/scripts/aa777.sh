#!/bin/bash
# #777's few large units again, with an A/A pair of each row: sqlite3.c and shell.c with -c, as one command by #777's head
# (015ca7c9) and as two processes at once by the same executable, each twice, 21 runs in a rotating order (time-runs), CPUs
# 0 to 7, one hold of the host's lock.
set -u
W=$HOME/buster-fast-bench/units-152-claude
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="tackle #776-#779 (#777: a few large units)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
H=$E/tree-t777/build/compiler
sha256sum $H
S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
OUT=$W/aa777
rm -rf $OUT && mkdir -p $OUT && cd $OUT
echo "== lists 1 and 3: -c of both as one command; lists 2 and 4: -c of each, two processes at once"
lists=()
for k in 1 2; do
    lists+=(--list -c "taskset -c 0-7 $H -c $S/sqlite3.c $S/shell.c")
    lists+=(--list -c "taskset -c 0-7 $H -c -o a.o $S/sqlite3.c & taskset -c 0-7 $H -c -o b.o $S/shell.c & wait")
done
lock $H time-runs --executable /bin/sh --runs 21 "${lists[@]}" | results
echo aa777-finished
