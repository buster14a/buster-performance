#!/bin/bash
# Records with no Zen 5 row (#181), with the temporary logging: every Tier 0/Tier 1 test suite and the corpora at two -march levels.
set -u
C=/home/user/buster/build/compiler
S=/tmp/claude-0/-home-user-buster/ce9879f5-7c72-527a-85b6-ca21c70bb5bf/scratchpad
O=$S/inventory/out2
mkdir -p $O
rm -f $O/*
SQ=$S/corpus/sqlite
LU=$S/corpus/lua/src
for t in test-tier0 test-tier1-select test-tier1-pipeline test-tier1-masks test-tier1-emit test-tier1-cfg-source test-x86-target-selection test-tier1-wide test-tier1-frame-execution; do
  BUSTER_ZEN5_UNKNOWN=$O/$t.txt timeout 1200 $C $t > $O/$t.log 2>&1
  echo "$t exit $?"
done
for march in "" "-march=znver5"; do
  for tier in tier0 tier1; do
    opt=""; [ $tier = tier1 ] && opt="--tier1 -fno-asynchronous-unwind-tables"
    tag="$tier${march:+-znver5}"
    export BUSTER_ZEN5_UNKNOWN=$O/corpus-$tag.txt
    $C -c $opt $march -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQ $SQ/sqlite3.c -o $O/sq.o || echo "FAIL sqlite $tag"
    $C -c $opt $march -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQ $SQ/speedtest1.c -o $O/st.o || echo "FAIL speedtest1 $tag"
    for f in $LU/*.c; do $C -c $opt $march -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX $f -o $O/lua.o || echo "FAIL $f $tag"; done
    unset BUSTER_ZEN5_UNKNOWN
  done
done
wc -l $O/*.txt
