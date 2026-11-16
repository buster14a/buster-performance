#!/bin/bash
# census-run.sh COMPILER TAG: the plain census (no shadow) on the three corpora and the fixtures, its report lines kept.
set -u
compiler=$1; tag=$2
S=/tmp/claude-0/-home-user/d2e261bc-e319-52e6-9f39-10bb9f312ad8/scratchpad
c=~/corpora; musl=$c/libc/musl
out=$S/census/$tag
mkdir -p $out
$compiler measure-node-machine -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$c/sqlite $c/sqlite/sqlite3.c > $out/sqlite.txt 2>&1
$compiler measure-node-machine -Wall -Wextra -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$c/sqlite $c/sqlite/sqlite3.c > $out/sqlite-wall.txt 2>&1
$compiler measure-node-machine $c/lua-5.4.8/src/*.c > $out/lua.txt 2>&1
$compiler measure-node-machine -Wall -Wextra $c/lua-5.4.8/src/*.c > $out/lua-wall.txt 2>&1
files=(); declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi; done
mo=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$c/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$c/musl-generated/obj/include" -I "$musl/include")
$compiler measure-node-machine "${mo[@]}" "${files[@]}" > $out/musl.txt 2>&1
$compiler measure-node-machine -Wall -Wextra "${mo[@]}" "${files[@]}" > $out/musl-wall.txt 2>&1
F=$S/fixtures
for f in warnings set clean; do $compiler measure-node-machine --list 100 -nostdinc -Wall -Wextra -Wshift-sign-overflow -Wassign-enum $F/$f.c > $out/fx-$f.txt 2>&1; done
for f in quiet atomic; do $compiler measure-node-machine --list 100 -nostdinc $F/$f.c > $out/fx-$f.txt 2>&1; done
$compiler measure-node-machine --list 100 -nostdinc -Wall -Wextra -isystem $F/system $F/system.c > $out/fx-system.txt 2>&1
echo done > $out/done
