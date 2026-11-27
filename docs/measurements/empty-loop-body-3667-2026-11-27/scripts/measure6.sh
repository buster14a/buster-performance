#!/bin/bash
# #3667: base, v10 (the change's hot paths, its cold helper empty) built in var, and head (41e9fcab), alternating, four
# rounds of measure-compile --runs 5 on CI's sqlite3.c, each run under the lock.
cd ~/buster-fast-bench/3667-claude
export EXCLUSIVE_OWNER=3667-claude EXCLUSIVE_TITLE="Fail closed on empty for/while bodies in direct path" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3667
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
(cd var && git checkout -q -- src)
cp vars/v10/*.c var/src/buster/compiler/
(cd var && timeout 1200 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build6.log 2>&1 || echo "build var failed" >> status6.txt
for round in 1 2 3 4; do for t in base var head; do (cd $t && timeout 600 ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-compile --runs 5 -- "${args[@]}") > measure6-$t-$round.log 2>&1; done; done
(cd var && git checkout -q -- src)
echo done >> status6.txt
