#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD;cd ../switch-inputs;source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
clang -O0 -c "${args[@]}" -o "$d/sqlite-runtime-clang.o"
clang -O0 -I"$PWD/sqlite" -c "$d/sqlite-runtime.c" -o "$d/sqlite-runtime-driver.o"
i=0
for obj in "$d/sqlite-runtime-clang.o" "$d/../source-typed-study/sqlite.o" "$d/../member-chain-compact-study/profile-ordinary-on.o" "$d/../member-chain-spelling-study/sqlite.physical.chain.o" "$d/../member-chain-statements-study/sqlite.composed.chain.o" "$d/../member-chain-pure-record-study/sqlite.record.chain.o";do
 clang -no-pie "$d/sqlite-runtime-driver.o" "$obj" -lm -ldl -pthread -o "$d/sqlite-runtime-$i";"$d/sqlite-runtime-$i" > "$d/sqlite-runtime-$i.stdout"
 cmp "$d/sqlite-runtime-0.stdout" "$d/sqlite-runtime-$i.stdout"
 i=$((i+1))
done
