#!/bin/bash
# Inventory of the records Tier 0 and Tier 1 emit (#181), with the temporary instrumentation.
set -u
C=${COMPILER:-/home/user/buster/build/compiler}
S=/tmp/claude-0/-home-user-buster/ce9879f5-7c72-527a-85b6-ca21c70bb5bf/scratchpad
O=$S/inventory/out
mkdir -p $O
rm -f $O/*.txt
SQ=$S/corpus/sqlite
LU=$S/corpus/lua/src
for tier in tier0 tier1; do
  opt=""; [ $tier = tier1 ] && opt="--tier1 -fno-asynchronous-unwind-tables"
  export BUSTER_FORM_INVENTORY=$O/$tier-sqlite.txt
  $C -c $opt -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQ $SQ/sqlite3.c -o $O/sqlite3-$tier.o || echo "FAIL sqlite $tier"
  $C -c $opt -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQ $SQ/speedtest1.c -o $O/speedtest1-$tier.o || echo "FAIL speedtest1 $tier"
  export BUSTER_FORM_INVENTORY=$O/$tier-lua.txt
  for f in $LU/*.c; do
    $C -c $opt -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX $f -o $O/lua-$tier.o || echo "FAIL $f $tier"
  done
done
unset BUSTER_FORM_INVENTORY
BUSTER_FORM_INVENTORY=$O/test-tier0.txt $C test-tier0 > $O/test-tier0.log 2>&1 || echo "FAIL test-tier0"
BUSTER_FORM_INVENTORY=$O/test-tier1-select.txt $C test-tier1-select > $O/test-tier1-select.log 2>&1 || echo "FAIL test-tier1-select"
wc -l $O/*.txt
