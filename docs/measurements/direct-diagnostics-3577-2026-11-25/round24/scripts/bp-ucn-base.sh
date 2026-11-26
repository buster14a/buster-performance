#!/bin/bash
# bp-ucn-base.sh: CI's instruction check (measure-compile --runs 3 against the baseline file) with the gated variant's
# binary (b83a9671b, the tree of the PR's fix commit 969573021) and the merge's, in one hold.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
git -C "$D/work" show f8c4f8e1e:tools/ci/compile-instructions.txt > /tmp/3577-claude-baseline.txt
EXCLUSIVE_TITLE="#3577 direct path: read the instruction baseline" ~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1; D=$2
  for t in g merge; do
    echo "== $t"
    taskset -c 2 $D/bins/compiler-u-$t measure-compile --runs 3 --instructions-baseline /tmp/3577-claude-baseline.txt -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" 2>&1 | grep -iE "instruction|baseline|failure"
  done
' x "$sqlite" "$D"
echo DONE
