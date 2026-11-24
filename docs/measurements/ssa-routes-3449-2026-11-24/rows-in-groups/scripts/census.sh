#!/bin/bash
# census.sh EXE OUT [EXTRA]: --tier1 -c of sqlite3.c, Lua and musl with BUSTER_SSA_CENSUS lines into OUT.
EXE=$1; OUT=$2; EXTRA=${3:-}
C=/home/user/corpus; sqlite=$C/sqlite; musl=$C/libc/musl; lua=$C/lua-5.4.8/src
export LC_ALL=C BUSTER_SSA_CENSUS=1
W=${4:-$(mktemp -d)}; mkdir -p $W; : > $OUT
files=(); declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi; done
(cd $W && "$EXE" -c --tier1 $EXTRA --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o sqlite3.o 2>&1 >/dev/null | sed 's/^/sqlite /' >> $OUT); echo "sqlite ${PIPESTATUS[0]}"
(cd $W && "$EXE" -c --tier1 $EXTRA --lanes 1 "$lua"/*.c 2>&1 >/dev/null | sed 's/^/lua /' >> $OUT); echo "lua ${PIPESTATUS[0]}"
(cd $W && "$EXE" -c --tier1 $EXTRA --lanes 1 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$C/musl-generated/obj/include" -I "$musl/include" "${files[@]}" 2>&1 >/dev/null | sed 's/^/musl /' >> $OUT); echo "musl ${PIPESTATUS[0]}"
[ -n "${4:-}" ] || rm -rf $W
