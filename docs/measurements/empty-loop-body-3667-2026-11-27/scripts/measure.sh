#!/bin/bash
# #3667: base (main 6ac6c1d5) and head builds, then CI's instruction step on each, alternating, each run under the lock.
cd ~/buster-fast-bench/3667-claude
export EXCLUSIVE_OWNER=3667-claude EXCLUSIVE_TITLE="Fail closed on empty for/while bodies in direct path" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3667
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for t in base head; do (cd $t && timeout 1200 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build-$t.log 2>&1 || echo "build $t failed" >> status.txt; done
for round in 1 2 3; do for t in base head; do (cd $t && timeout 600 ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c") > measure-$t-$round.log 2>&1; done; done
echo done >> status.txt
