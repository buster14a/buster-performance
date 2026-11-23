#!/bin/bash
# #2924 C12c-5 (a): the bindings' twins deleted, c_bindings_sort's one form. head = the
# deletion (d5c2d4de), base = the tests commit before it (dd9fae6e, the twins present), on main 968a085f, from the bundle
# beside this script; Release, every run under the lock (one locked run each), timings on CPU 2 (the deferred list on
# CPUs 2 to 9).
# (Objects and stderr are compared in the session's container, objects.sh, to keep the shared lock's queue short.)
# ab, three rounds, around time-runs (three runs of two copies) of base, head and base again: -c --lanes 1 -Wall
#    -Wextra of sqlite3.c, Lua's units and musl's units; -c --lanes 1 of sqlite3.c and musl's units with no warning
#    option; -c --lanes 4 --deferred-bodies of sqlite3.c.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924-front EXCLUSIVE_TITLE="buster #2924 C12c-5: bindings" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=~/buster-fast-bench/2924-c-df-claude
mkdir -p logs compilers
: > logs/status.txt
for tree in base head; do
    if [ ! -d src-$tree ]; then git clone -q --shared $P/c7gate/src src-$tree || exit 1; fi
    git -C src-$tree fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$tree fetch -q "$D/front-a.bundle" 'refs/heads/*:refs/remotes/bundle/*' || { echo "bundle failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach dd9fae6e && git -C src-base reset -q --hard
git -C src-head checkout -q --detach d5c2d4de && git -C src-head reset -q --hard
for tree in base head; do
    (cd src-$tree && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$tree.log" 2>&1) || { echo "build $tree failed" >> logs/status.txt; exit 1; }
    cp src-$tree/build/compiler compilers/$tree
done
echo "built base $(git -C src-base rev-parse --short HEAD) head $(git -C src-head rev-parse --short HEAD)" >> logs/status.txt
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/c3pr/inputs/lua-5.4.8/src
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
W=(-Wall -Wextra)
out=/dev/shm/claude-2924-front-a
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
for list in sqlite-wall lua-wall musl-wall sqlite musl dsqlite; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite-wall) args=(-c --lanes 1 "${W[@]}" "${S[@]}" -o "$out/sqlite3.o");;
        lua-wall) args=(-c --lanes 1 "${W[@]}" "$lua"/*.c);;
        musl-wall) args=(-c --lanes 1 "${W[@]}" "${M[@]}" "${files[@]}");;
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
        dsqlite) args=(-c --lanes 4 --deferred-bodies "${S[@]}" -o "$out/sqlite3.o");;
    esac
    if [ "$list" = dsqlite ]; then
        (cd "$out" && taskset -c 2-9 "$D/compilers/base" ab --rounds 3 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
            -- time-runs --runs 3 --copies 2 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    else
        (cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
            -- time-runs --runs 3 --copies 2 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    fi
    echo "time $list: $?" >> logs/status.txt
done
rm -rf "$out"
for tree in base head; do
    idx=$(readelf -SW compilers/$tree | sed -n 's/^ *\[ *\([0-9]*\)\] \.text\.buster_start .*/\1/p')
    readelf -sW compilers/$tree | awk -v i="$idx" '$4 == "FUNC" && $7 == i {print $8}' | sort -u > logs/start-$tree.txt
done
echo done >> logs/status.txt
