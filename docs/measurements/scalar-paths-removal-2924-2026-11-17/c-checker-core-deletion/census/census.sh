#!/bin/bash
# #2924 C12c-3: which of the checker core's scalar-path selectors each list reaches, and with which value. The tree is
# main 198a76539 with census.patch: BUSTER_SCALAR_PATH and BUSTER_VECTOR_PATH count each use by file and line, and the
# plain selectors (the actions' and the wide kernels' own flags, the attributes' locals, the overload index's) go through
# them. -c --lanes 1 of sqlite3.c, Lua's units, musl's units and buster's main.c (the complete driver), by default, with
# -Wall -Wextra and with --scalar, each under the lock; BUSTER_PATH_CENSUS=FILE appends every site's counts at exit
# (BUSTER_EXIT_HELPER=0: the helper closes the descriptors first).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's census, C12c-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
: > logs/status.txt
rm -f logs/*.census
if [ ! -d tree ]; then git clone -q --shared $D/../c7gate/src tree || exit 1; fi
git -C tree fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
git -C tree checkout -q --detach 198a76539 && git -C tree reset -q --hard && (cd tree && patch -p1 -s < "$D/census.patch") || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd tree && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp tree/build/compiler compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$D/../c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(-march=znver5 -I"$D/tree/src" -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_COMPLETE_DRIVER=1 "$D/tree/src/buster/compiler/main.c")
out=/dev/shm/claude-2924-c12k-census
for mode in default wall scalar; do
    case $mode in default) opt=();; wall) opt=(-Wall -Wextra);; scalar) opt=(--scalar);; esac
    rm -rf "$out"; mkdir -p "$out"
    for list in sqlite lua musl buster; do
        case $list in
            sqlite) args=("${S[@]}" -o "$out/sqlite3.o");;
            lua) args=("$lua"/*.c);;
            musl) args=("${M[@]}" "${files[@]}");;
            buster) args=("${B[@]}" -o "$out/main.o");;
        esac
        (cd "$out" && BUSTER_PATH_CENSUS="$D/logs/$mode-$list.census" BUSTER_EXIT_HELPER=0 $L timeout -k 5 1500 taskset -c 2 "$D/compiler" -c --lanes 1 "${opt[@]}" "${args[@]}" > /dev/null 2> "$D/logs/$mode-$list.err")
        echo "census $mode $list: $? ($(wc -l < "$D/logs/$mode-$list.census" 2>/dev/null) lines)" >> logs/status.txt
    done
done
rm -rf "$out"
echo done >> logs/status.txt
