#!/bin/bash
set -eu
cd "$(dirname "$0")";here=$PWD
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
cd ../switch-inputs;source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
"$cc" -c "${args[@]}" -o "$here/sqlite-clang.o" 2>"$here/sqlite-clang.stderr"
"$cc" -I"$sqlite" -c "$here/sqlite-driver.c" -o "$here/sqlite-driver.o"
for m in clang baseline candidate;do
 case $m in clang) o=$here/sqlite-clang.o;; baseline) o=$here/../inactive-source-study/sqlite-control.o;;candidate) o=$here/sqlite.o;;esac
 "$cc" -no-pie "$here/sqlite-driver.o" "$o" -lm -ldl -lpthread -o "$here/sqlite-$m"
 "$here/sqlite-$m" >"$here/runtime-$m.stdout" 2>"$here/runtime-$m.stderr"
 cmp "$here/runtime-clang.stdout" "$here/runtime-$m.stdout";cmp "$here/runtime-clang.stderr" "$here/runtime-$m.stderr"
done
