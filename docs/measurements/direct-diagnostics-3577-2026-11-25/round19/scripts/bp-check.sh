#!/bin/bash
# bp-check.sh: perf stat rotation of main16, m16 and p8 (4 rounds of 7) and whether main16 takes tier1_patterns.c direct.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597 EXCLUSIVE_TITLE="#3577 direct path: recheck the squashed head"
cd "$D" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-c.o)
  uptime
  for r in 1 2 3 4; do
    for t in main16 m16 p8; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u,page-faults:u ./bins/compiler-$t "${flags[@]}" 2>&1 | grep -E "cycles|instructions|faults" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
  for t in main16 p8; do
    ./bins/compiler-$t -c repo/tests/driver/tier1_patterns.c -o /tmp/3577-claude-t.o 2>&1 | head -3; echo "$t tier1_patterns: $(readelf -p .comment /tmp/3577-claude-t.o | grep -o "buster[a-z -]*")"
  done
' x "$sqlite"
echo DONE
