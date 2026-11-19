#!/bin/bash
# #2924 C12c's gate, step 1 (checks before any timing): main 1962b1f73 plus c12c-areas-knob.patch (EXPERIMENT ONLY: the
# checker's and the program's scalar paths gated by area where the flag's name is defined; the executable takes its
# bits from its file's name, compiler-areasN). Release, every run under the lock on CPU 2.
# 1. Objects: -c --lanes 1 of sqlite3.c, Lua, musl's units and buster's main.c by main and by the knob executable with
#    no bit, each bit alone, the roots together (2..7) and the areas together (10..28): every object compared with main's.
# 2. Closure: time-runs --runs 1 of no bit, the roots and the areas, one list at a time, for their instructions.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker's area gate, C12c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p logs compilers
for tree in main knob; do
    if [ ! -d src-$tree ]; then git clone -q --shared $D/../c7gate/src src-$tree || exit 1; fi
    git -C src-$tree fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$tree checkout -q --detach 1962b1f73 && git -C src-$tree reset -q --hard && git -C src-$tree clean -qfd -e build
done
(cd src-knob && patch -p1 < "$D/c12c-areas-knob.patch" > "$D/logs/patch.log" 2>&1) || { echo "patch failed" >> logs/status.txt; exit 1; }
for tree in main knob; do
    (cd src-$tree && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$tree.log" 2>&1) || { echo "build $tree failed" >> logs/status.txt; exit 1; }
done
cp src-main/build/compiler compilers/main
names=(none roots areas)
masks=(0 252 $(( (1 << 29) - (1 << 10) )))
for b in 2 3 4 5 6 7 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28; do names+=(bit$b); masks+=($((1 << b))); done
for i in "${!masks[@]}"; do cp src-knob/build/compiler compilers/compiler-areas${masks[$i]}; done
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
B=(-march=znver5 -I"$D/src-main/src" -fwrapv -funsigned-char -fno-strict-aliasing "$D/src-main/src/buster/compiler/main.c")
objects=/dev/shm/claude-2924-c12c-objects
rm -rf "$objects"
all=(main "${names[@]}")
for name in "${all[@]}"; do
    if [ "$name" = main ]; then exe="$D/compilers/main"; else
        for i in "${!names[@]}"; do [ "${names[$i]}" = "$name" ] && exe="$D/compilers/compiler-areas${masks[$i]}"; done
    fi
    cur=$objects/$name
    mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster"
    (cd "$cur/sqlite" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr-$name.txt"); echo "objects $name sqlite: $?" >> logs/status.txt
    (cd "$cur/lua" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "$lua"/*.c > /dev/null 2>> "$D/logs/stderr-$name.txt"); echo "objects $name lua: $?" >> logs/status.txt
    (cd "$cur/musl" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr-$name.txt"); echo "objects $name musl: $?" >> logs/status.txt
    (cd "$cur/buster" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${B[@]}" -o main.o > /dev/null 2>> "$D/logs/stderr-$name.txt"); echo "objects $name buster: $?" >> logs/status.txt
done
for name in "${names[@]}"; do
    n=0; d=0
    while read -r f; do
        n=$((n+1))
        cmp -s "$objects/main/$f" "$objects/$name/$f" || { d=$((d+1)); echo "differs $name: $f" >> logs/objects-compare.txt; }
    done < <(cd "$objects/main" && find . -name '*.o' | sort)
    m=$(cd "$objects/$name" && find . -name '*.o' | wc -l)
    echo "objects $name: $n compared, $d differ, $m made" >> logs/status.txt
done
rm -rf "$objects"
out=/dev/shm/claude-2924-c12c
BUILDS=(--build none "$D/compilers/compiler-areas0" --build roots "$D/compilers/compiler-areas252" --build areas "$D/compilers/compiler-areas${masks[2]}")
for list in sqlite lua musl; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
    esac
    (cd "$out" && "$D/compilers/main" ab --rounds 1 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
        -- time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/closure-$list.log" 2>&1)
    echo "closure $list: $?" >> logs/status.txt
done
rm -rf "$out"
echo done >> logs/status.txt
