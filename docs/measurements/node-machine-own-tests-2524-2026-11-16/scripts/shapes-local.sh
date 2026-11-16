#!/bin/bash
# shapes-local.sh COMPILER CORPUS [extra options]: measure-node-machine --shadow --shapes on a cloud copy (sqlite, lua, musl).
set -u
compiler=$1; corpus=$2; shift 2
c=~/corpora
musl=$c/libc/musl
case $corpus in
  sqlite) $compiler measure-node-machine --shadow "$@" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$c/sqlite $c/sqlite/sqlite3.c ;;
  lua) $compiler measure-node-machine --shadow "$@" $c/lua-5.4.8/src/*.c ;;
  musl)
    files=(); declare -A seen
    for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi; done
    mo=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$c/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$c/musl-generated/obj/include" -I "$musl/include")
    $compiler measure-node-machine --shadow "$@" "${mo[@]}" "${files[@]}" ;;
esac
