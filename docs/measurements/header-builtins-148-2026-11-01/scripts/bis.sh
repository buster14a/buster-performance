#!/bin/bash
cd ~/buster-fast-bench/header-148
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="#148: x86 header builtins (bisect)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1040
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for v in tb823d1c t3dcb96b vA vB; do (cd $v && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; echo "build $v $?" >> ../bis.status); done
for r in 1 2; do for v in tb823d1c t3dcb96b vA vB; do
~/buster-fast-bench/exclusive.sh perf stat -x, -e instructions:u taskset -c 2 ./$v/build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /tmp/bis-$v.o 2>&1 >/dev/null | grep instructions | sed "s/^/sqlite $v /" >> bis.status
~/buster-fast-bench/exclusive.sh perf stat -x, -e instructions:u taskset -c 2 ./$v/build/compiler -c -march=native -Istb stb/stb_image.c -o /tmp/bis-stb-$v.o 2>&1 >/dev/null | grep instructions | sed "s/^/stb $v /" >> bis.status
done; done
cmp /tmp/bis-tb823d1c.o /tmp/bis-t3dcb96b.o && echo same-sqlite >> bis.status
echo done >> bis.status
