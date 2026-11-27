#!/bin/bash
# bp-count.sh V...: builds each lex-V.c in work/ (one hold per build) as bin/compiler.V, then runs one sqlite3.c compile of
# each under its own hold: the skip's instructions (skip-count, from counted builds) and the whole compile's (perf stat).
cd ~/buster-fast-bench/3577-claude-splice
export EXCLUSIVE_OWNER=claude-session_01TiDLntzjiBRBBPKQphvMQe
export EXCLUSIVE_TITLE="Fix spliced-line conditionals in direct-path skip (#3577 follow-up)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3577
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for v in "$@"; do
  if [ ! -x bin/compiler.$v ] || [ lex-$v.c -nt bin/compiler.$v ]; then
    cp lex-$v.c work/src/buster/compiler/c_direct_lex.c
    ./bp-build.sh work $v > /dev/null
  fi
done
for v in "$@"; do
  r=$(~/buster-fast-bench/exclusive.sh timeout 120 taskset -c 2 perf stat -x, -e instructions:u -- bin/compiler.$v -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /tmp/3577-claude-splice-count.o 2>&1)
  printf '%s skip %s total %s\n' "$v" "$(cat /tmp/3577-claude-skip-count.txt 2>/dev/null)" "$(printf '%s\n' "$r" | grep instructions | cut -d, -f1)"
  rm -f /tmp/3577-claude-skip-count.txt
done
