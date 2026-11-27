#!/bin/bash
# #3667: head at the branch tip (41e9fcab) rebuilt, then base and head alternating, five rounds of measure-compile
# --runs 5 on CI's sqlite3.c, each run under the lock.
cd ~/buster-fast-bench/3667-claude
export EXCLUSIVE_OWNER=3667-claude EXCLUSIVE_TITLE="Fail closed on empty for/while bodies in direct path" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3667
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
(cd head && git fetch -q https://github.com/buster14a/buster claude/loving-volta-ycew42 && git checkout -q FETCH_HEAD && git log --oneline -1) > head5.txt 2>&1
(cd head && timeout 1200 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build-head5.log 2>&1 || echo "build head failed" >> status5.txt
for round in 1 2 3 4 5; do for t in base head; do (cd $t && timeout 600 ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-compile --runs 5 -- "${args[@]}") > measure5-$t-$round.log 2>&1; done; done
echo done >> status5.txt
