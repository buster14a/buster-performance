#!/bin/bash
# #2924 C12c-3 core-3's census: which of group A's selectors each mode reaches. The tree is core-2's head 88741d83b with
# host_isa.h's counting macros and the plain selectors wrapped (overload index, unsequenced, deferred entries).
set -uo pipefail
C=/root/.cache/claude-c7/c12k/census
T=$C/tree3
X=$C/compiler3
O=$C/logs3
S=/tmp/claude-0/-home-user/a5cf9d3c-54b3-5f35-a2b2-f7ae4ba74bd8/scratchpad/core3
mkdir -p $O; rm -f $O/*.census; : > $O/status.txt
corpus=/root/.cache/claude-c7/corpus/tree
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
SQ=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(-march=native -I"$T/src" -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_COMPLETE_DRIVER=1 "$T/src/buster/compiler/main.c")
out=/dev/shm/claude-2924-core3-census
for mode in default wall deferred syntax scalar; do
    case $mode in default) opt=(-c --lanes 1);; wall) opt=(-c --lanes 1 -Wall -Wextra);; deferred) opt=(-c --lanes 4 --deferred-bodies -Wall);; syntax) opt=(-fsyntax-only -Wall);; scalar) opt=(-c --lanes 1 -Wall --scalar);; esac
    for list in sqlite musl buster fixture; do
        rm -rf "$out"; mkdir -p "$out"
        case $list in
            sqlite) args=("${SQ[@]}");;
            musl) args=("${M[@]}" "${files[@]}");;
            buster) args=("${B[@]}");;
            fixture) args=("$S/overloadable.c");;
        esac
        (cd "$out" && BUSTER_PATH_CENSUS="$O/$mode-$list.census" BUSTER_EXIT_HELPER=0 timeout -k 5 1500 "$X" "${opt[@]}" "${args[@]}" > /dev/null 2> "$O/$mode-$list.err")
        echo "census $mode $list: $? ($(wc -l < "$O/$mode-$list.census" 2>/dev/null) lines)" >> $O/status.txt
    done
done
rm -rf "$out"
echo done >> $O/status.txt
