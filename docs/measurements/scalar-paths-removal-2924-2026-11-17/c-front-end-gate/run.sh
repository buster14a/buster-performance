#!/bin/bash
# #2924 C12's gate: the front end's stages, each sent to its scalar path alone, on main 0c113feb1 plus
# c12-areas-knob.patch (EXPERIMENT ONLY: the executable takes its stages' bits from its file's name, compiler-areasN).
# Stages (bit k, mask 1<<k): 1 the preprocessor, 2 the parser (and the reader's parts that read its flag), 3 the lazy
# planner, 4 the checker, 5 the static data, 6 the program and its lowering, 7 selection, target features and aliases.
# Release, every run under the lock on CPU 2:
# 1. -c --lanes 1 objects of sqlite3.c, Lua, musl and buster's main.c by every build, compared with no bit's;
# 2. ab, three rounds, around time-runs of the eight builds (three runs each), one list at a time: sqlite3.c, Lua's units
#    and musl's units, -c --lanes 1.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the front end's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p logs compilers
if [ ! -d src ]; then git clone -q --shared $D/../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
git -C src checkout -q --detach 0c113feb1 && git -C src reset -q --hard
(cd src && patch -p1 < "$D/c12-areas-knob.patch" > "$D/logs/patch.log" 2>&1) || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
for mask in 0 2 4 8 16 32 64 128; do cp src/build/compiler compilers/compiler-areas$mask; done
names=(none preprocessor parser lazy checker data program select)
masks=(0 2 4 8 16 32 64 128)
sha256sum compilers/* > logs/compilers.sha256
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
B=(-march=znver5 -I"$D/src/src" -fwrapv -funsigned-char -fno-strict-aliasing "$D/src/src/buster/compiler/main.c")
objects=/dev/shm/claude-2924-c12-objects
rm -rf "$objects"
for i in "${!masks[@]}"; do
    exe="$D/compilers/compiler-areas${masks[$i]}"
    cur=$objects/${names[$i]}
    mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster"
    (cd "$cur/sqlite" && $L timeout -k 5 1500 "$exe" -c --lanes 1 "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr-${names[$i]}.txt"); echo "objects ${names[$i]} sqlite: $?" >> logs/status.txt
    (cd "$cur/lua" && $L timeout -k 5 1500 "$exe" -c --lanes 1 "$lua"/*.c > /dev/null 2>> "$D/logs/stderr-${names[$i]}.txt"); echo "objects ${names[$i]} lua: $?" >> logs/status.txt
    (cd "$cur/musl" && $L timeout -k 5 1500 "$exe" -c --lanes 1 "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr-${names[$i]}.txt"); echo "objects ${names[$i]} musl: $?" >> logs/status.txt
    (cd "$cur/buster" && $L timeout -k 5 1500 "$exe" -c --lanes 1 "${B[@]}" -o main.o > /dev/null 2>> "$D/logs/stderr-${names[$i]}.txt"); echo "objects ${names[$i]} buster: $?" >> logs/status.txt
done
for i in 1 2 3 4 5 6 7; do
    n=0; d=0
    while read -r f; do
        n=$((n+1))
        cmp -s "$objects/none/$f" "$objects/${names[$i]}/$f" || { d=$((d+1)); echo "differs ${names[$i]}: $f" >> logs/objects-compare.txt; }
    done < <(cd "$objects/none" && find . -name '*.o' | sort)
    echo "objects ${names[$i]}: $n compared, $d differ" >> logs/status.txt
done
rm -rf "$objects"
out=/dev/shm/claude-2924-c12
BUILDS=()
for i in "${!masks[@]}"; do BUILDS+=(--build "${names[$i]}" "$D/compilers/compiler-areas${masks[$i]}"); done
for list in sqlite lua musl; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
    esac
    (cd "$out" && "$D/compilers/compiler-areas0" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/compiler-areas0" \
        -- time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
rm -rf "$out"
echo done >> logs/status.txt
