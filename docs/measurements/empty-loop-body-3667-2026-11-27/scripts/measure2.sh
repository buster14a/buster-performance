#!/bin/bash
# #3667: head at the branch tip, rebuilt; CI's instruction step on base and head, alternating; then instruction samples
# of 20 compiles each. Each run under the lock.
cd ~/buster-fast-bench/3667-claude
export EXCLUSIVE_OWNER=3667-claude EXCLUSIVE_TITLE="Fail closed on empty for/while bodies in direct path" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3667
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
(cd head && git fetch -q https://github.com/buster14a/buster claude/loving-volta-ycew42 && git checkout -q FETCH_HEAD && git log --oneline -1) > head2.txt 2>&1
(cd head && timeout 1200 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build-head2.log 2>&1 || echo "build head failed" >> status2.txt
for round in 1 2 3; do for t in base head; do (cd $t && timeout 600 ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${args[@]}") > measure2-$t-$round.log 2>&1; done; done
for t in base head; do (cd $t && timeout 600 ~/buster-fast-bench/exclusive.sh perf record -q -e instructions:u -c 20011 -o ../perf-$t.data -- taskset -c 2 bash -c "for i in \$(seq 20); do ./build/compiler ${args[*]} -o /tmp/3667-claude-$t.o; done") > perf-$t.log 2>&1; done
for t in base head; do perf report -i perf-$t.data --sort symbol --stdio --percent-limit 0.005 2>/dev/null | grep -v "^#" | grep -v "^$" > report-$t.txt; done
echo done >> status2.txt
