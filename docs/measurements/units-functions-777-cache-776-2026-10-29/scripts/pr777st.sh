#!/bin/bash
# #777's few large units by stage: --time-stages of -c sqlite3.c shell.c as one command and of -c sqlite3.c alone, by
# tree-t777s, five runs each in turn, one hold of the host's lock.
set -u
W=$HOME/buster-fast-bench/units-152-claude
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="tackle #776-#779 (#777: a few large units)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
H=$E/tree-t777s/build/compiler
S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
OUT=$W/pr777st
rm -rf $OUT && mkdir -p $OUT && cd $OUT
ls -l $S/sqlite3.c $S/shell.c | awk '{print $5, $9}'
lock bash -c "for r in 1 2 3 4 5; do echo \"units run \$r\"; taskset -c 0-7 $H --time-stages -c $S/sqlite3.c $S/shell.c 2>&1 | grep -E '^time-stage.(setup|lanes|release|total)|^time-process.(user|system|peak)'; echo \"alone run \$r\"; taskset -c 0-7 $H --time-stages -c -o a.o $S/sqlite3.c 2>&1 | grep -E '^time-stage|^time-process.(user|system|peak)'; done"
echo pr777st-finished
