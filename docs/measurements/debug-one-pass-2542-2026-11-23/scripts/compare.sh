#!/bin/bash
# compare.sh OLD NEW [EXTRA]: -g outputs of both compilers, byte for byte, with EXTRA options (--tier1, or none): sqlite3.c
# and shell.c objects, the shell's executable (1 and 7 lanes), and every musl unit's -c -g object.
old=$1/build/compiler; new=$2/build/compiler; extra=$3
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite; musl=$corpus/libc/musl
sh="-DSQLITE_DQS=0 -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION -DSQLITE_ENABLE_STMTVTAB -DSQLITE_ENABLE_DBPAGE_VTAB -DSQLITE_ENABLE_DBSTAT_VTAB -DSQLITE_ENABLE_BYTECODE_VTAB -DSQLITE_ENABLE_OFFSET_SQL_FUNC -DSQLITE_ENABLE_PERCENTILE -DSQLITE_STRICT_SUBTYPE=1 -DSQLITE_ENABLE_MATH_FUNCTIONS -I$sqlite"
mo="-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include"
out=/tmp/2542-claude/compare$extra; rm -rf $out; mkdir -p $out/old $out/new
export XDG_CACHE_HOME=/tmp/2542-claude/cache LC_ALL=C
same=0; differ=0; failed=0
check() { if cmp -s $out/old/$1 $out/new/$1; then same=$((same+1)); else differ=$((differ+1)); echo "DIFFER $1"; fi; }
for u in sqlite3 shell; do
  for v in old new; do c=${!v}; $c $sh -g $extra -c $sqlite/$u.c -o $out/$v/$u.o; done; check $u.o
done
for l in 1 7; do
  for v in old new; do c=${!v}; $c $sh -g $extra --lanes $l $sqlite/shell.c $sqlite/sqlite3.c -lm -o $out/$v/shell-$l; done; check shell-$l
done
n=0
for f in $(find $musl/src -name '*.c' | sort); do
  n=$((n+1)); b=m$n.o
  $old $mo -g $extra -c $f -o $out/old/$b 2>/dev/null || { failed=$((failed+1)); continue; }
  $new $mo -g $extra -c $f -o $out/new/$b 2>/dev/null
  check $b
done
echo "extra=$extra same=$same differ=$differ old-failed=$failed"
echo 'select 6*7, sqlite_version(), sqrt(2.0);' | $out/new/shell-1
for f in sqlite3.o shell.o; do printf '%s inlined subroutines: ' $f; llvm-dwarfdump --debug-info $out/new/$f 2>/dev/null | grep -c DW_TAG_inlined_subroutine; done
