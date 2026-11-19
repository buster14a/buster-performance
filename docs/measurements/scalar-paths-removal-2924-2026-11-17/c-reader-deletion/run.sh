#!/bin/bash
# #2924 C12c-1: the reader's twins deleted. head = the deletion, base = the tests commit before it (the twins present),
# both on main 8bdb83b8d; Release, every run under the lock, timings on CPU 2.
# 1. Objects and stderr: -c --lanes 1 of sqlite3.c, Lua, musl's units and buster's main.c (the complete driver) by base
#    and head, each by default, with --scalar (head's --scalar keeps the other areas' twins over a vector reader) and
#    with --tier1, every object and stderr compared with base's of the same mode.
# 2. ab, three rounds, around time-runs (three runs of three copies) of base, head and base again: -c --lanes 1 of
#    sqlite3.c, Lua's units and musl's units, and -fsyntax-only of sqlite3.c.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the reader, C12c-1" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p logs compilers
for tree in base head; do
    if [ ! -d src-$tree ]; then git clone -q --shared $D/../c7gate/src src-$tree || exit 1; fi
    git -C src-$tree fetch -q https://github.com/buster14a/buster claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach dc1514dfa && git -C src-base reset -q --hard
git -C src-head checkout -q --detach fd9bb83f5 && git -C src-head reset -q --hard
for tree in base head; do
    (cd src-$tree && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$tree.log" 2>&1) || { echo "build $tree failed" >> logs/status.txt; exit 1; }
    cp src-$tree/build/compiler compilers/$tree
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(-march=znver5 -I"$D/src-base/src" -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_COMPLETE_DRIVER=1 "$D/src-base/src/buster/compiler/main.c")
objects=/dev/shm/claude-2924-c12c1-objects
rm -rf "$objects"
for mode in default scalar tier1; do
    case $mode in default) opt=();; scalar) opt=(--scalar);; tier1) opt=(--tier1);; esac
    for tree in base head; do
        exe="$D/compilers/$tree"
        cur=$objects/$mode/$tree
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster"
        (cd "$cur/sqlite" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$cur/sqlite.err"); echo "objects $mode $tree sqlite: $?" >> logs/status.txt
        (cd "$cur/lua" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "$lua"/*.c > /dev/null 2> "$cur/lua.err"); echo "objects $mode $tree lua: $?" >> logs/status.txt
        (cd "$cur/musl" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${M[@]}" "${files[@]}" > /dev/null 2> "$cur/musl.err"); echo "objects $mode $tree musl: $?" >> logs/status.txt
        (cd "$cur/buster" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${B[@]}" -o main.o > /dev/null 2> "$cur/buster.err"); echo "objects $mode $tree buster: $?" >> logs/status.txt
    done
    n=0; d=0
    while read -r f; do
        n=$((n+1)); cmp -s "$objects/$mode/base/$f" "$objects/$mode/head/$f" || { d=$((d+1)); echo "differs $mode: $f" >> logs/objects-compare.txt; }
    done < <(cd "$objects/$mode/base" && find . -name '*.o' -o -name '*.err' | sort)
    echo "objects and stderr $mode: $n compared, $d differ" >> logs/status.txt
done
# Each mode's objects against the default's (base): one set of bytes whatever the path.
for mode in scalar tier1; do
    n=0; d=0
    while read -r f; do
        n=$((n+1)); cmp -s "$objects/default/base/$f" "$objects/$mode/head/$f" || d=$((d+1))
    done < <(cd "$objects/default/base" && find . -name '*.o' | sort)
    echo "objects $mode head against default base: $n compared, $d differ" >> logs/status.txt
done
rm -rf "$objects"
out=/dev/shm/claude-2924-c12c1
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
for list in sqlite lua musl syntax; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
        syntax) args=(-fsyntax-only "${S[@]}");;
    esac
    (cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
        -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
rm -rf "$out"
for tree in base head; do readelf -sW compilers/$tree | awk '$7 != "UND" && $4 == "FUNC" {print $8}' | sort > logs/functions-$tree.txt; done
echo done >> logs/status.txt
