#!/bin/bash
# verify-local.sh COMPILER BATCH: --verify --passes 0 --batch BATCH on the cloud copies of sqlite3.c, Lua and musl, +-g.
set -u
compiler=$1; batch=$2
c=~/corpora
musl=$c/libc/musl
files=(); declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi; done
mo=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$c/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$c/musl-generated/obj/include" -I "$musl/include")
for g in "" "-g"; do
  echo "== sqlite $g"; $compiler measure-node-machine --shadow --verify --passes 0 --batch $batch $g -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$c/sqlite $c/sqlite/sqlite3.c 2>&1 | grep "node-shadow: \(differences\|batch\|machine-taken\)"; echo "status ${PIPESTATUS[0]}"
  echo "== lua $g"; $compiler measure-node-machine --shadow --verify --passes 0 --batch $batch $g $c/lua-5.4.8/src/*.c 2>&1 | grep "node-shadow: \(differences\|batch\|machine-taken\)"; echo "status ${PIPESTATUS[0]}"
  echo "== musl $g"; $compiler measure-node-machine --shadow --verify --passes 0 --batch $batch $g "${mo[@]}" "${files[@]}" 2>&1 | grep "node-shadow: \(differences\|batch\|machine-taken\)"; echo "status ${PIPESTATUS[0]}"
done
