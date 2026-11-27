#!/bin/bash
# bp-measure.sh TAG...: CI's "Hold sqlite3.c's compile to its instructions' baseline" with bin/compiler.TAG, one hold per run
cd ~/buster-fast-bench/3577-claude-splice/base
export EXCLUSIVE_OWNER=claude-session_01TiDLntzjiBRBBPKQphvMQe
export EXCLUSIVE_TITLE="Fix spliced-line conditionals in direct-path skip (#3577 follow-up)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3577
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for tag in "$@"; do
  ~/buster-fast-bench/exclusive.sh timeout 300 bash -c "uptime; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4; taskset -c 2 ../bin/compiler.$tag measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /tmp/3577-claude-splice.o" > ../logs/measure-$tag.log 2>&1
  echo "== $tag"; grep -i "instruction" ../logs/measure-$tag.log | head -5
done
