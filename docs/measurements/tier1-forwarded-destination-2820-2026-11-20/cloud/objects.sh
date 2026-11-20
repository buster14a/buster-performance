#!/bin/bash
# objects.sh COMPILER TAG: --tier1 -c of Lua 5.4.8's units and SQLite 3.54.1's amalgamation into objects/TAG/, a line
# each: unit, status, SHA-256, .text bytes.
set -u
B=$1; T=$2; D=/tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad/corpora
mkdir -p $D/objects/$T
: > $D/objects/$T.tsv
for f in $D/lua-5.4.8/src/*.c; do
    o=$D/objects/$T/lua-$(basename $f .c).o
    "$B" --tier1 -O2 -march=znver5 --lanes 1 -w -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c "$f" -o "$o" 2>/dev/null; s=$?
    printf '%s\t%s\t%s\t%s\n' "lua/$(basename $f)" $s "$(sha256sum < $o 2>/dev/null | cut -c1-16)" "$(size -A $o 2>/dev/null | awk '$1==".text"{print $2}')" >> $D/objects/$T.tsv
done
o=$D/objects/$T/sqlite3.o
"$B" --tier1 -O2 -march=znver5 --lanes 1 -w -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION -c $D/sqlite-amalgamation-3540100/sqlite3.c -o $o 2>/dev/null; s=$?
printf '%s\t%s\t%s\t%s\n' sqlite3.c $s "$(sha256sum < $o 2>/dev/null | cut -c1-16)" "$(size -A $o 2>/dev/null | awk '$1==".text"{print $2}')" >> $D/objects/$T.tsv
