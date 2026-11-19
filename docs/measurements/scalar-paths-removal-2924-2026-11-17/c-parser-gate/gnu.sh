#!/bin/bash
# benchmark-gnu (the GNU records' collection by its vector and scalar candidates) on sqlite3.c, buster's main.c, one Lua
# unit and one musl unit, three times each, under the lock on CPU 2, by the gate's stock executable.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the parser's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(-march=znver5 -I"$D/src/src" -fwrapv -funsigned-char --predefines "$D/predefines.h" -DBUSTER_COMPLETE_DRIVER=1 "$D/src/src/buster/compiler/main.c")
mkdir -p logs3
for round in 1 2 3; do
    for input in sqlite buster lua-one musl-one; do
        case $input in
            sqlite) args=("${S[@]}");;
            buster) args=("${B[@]}");;
            lua-one) args=("$lua/lapi.c");;
            musl-one) args=("${M[@]}" "$musl/src/string/strlen.c");;
        esac
        cp compilers/compiler-areas0 compilers/gnu-run
        $L timeout -k 5 900 taskset -c 2 ./compilers/gnu-run benchmark-gnu "${args[@]}" > "logs3/gnu-$round-$input.log" 2>&1; echo "gnu $round $input: $?" >> logs3/status.txt
        rm -f compilers/gnu-run
    done
done
echo done >> logs3/status.txt
