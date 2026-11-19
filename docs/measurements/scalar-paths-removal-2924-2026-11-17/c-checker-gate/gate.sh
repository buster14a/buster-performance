#!/bin/bash
# #2924 C12c's gate, step 2 (after checks.sh passed): the checker's and the program's areas, each sent to its scalar path
# alone, timed against no bit. The knob executable of checks.sh (compilers/compiler-areasN, one copy per setting).
# Groups of builds, each with two no-bit copies (none, none-again): ab, three rounds, around time-runs (three runs each),
# one group and one list at a time: sqlite3.c, Lua's units and musl's units, -c --lanes 1, under the lock on CPU 2.
# Bits: 10 reader, 11 bindings, 12 warnings, 13 attested, 14 core, 15 program, 16 lowering, 17 alias, 18 emit,
# 19 select, 20 asm, 21 driver, 22 foreign (types, bindings' sort, builtins' fold and filter), 23 static data, 24 lazy
# planner (does not run without -flazy-system-headers: a control), 25 node machine, 26 the checker's Tier 1, 27 the
# builtins' lowering, 28 emission's (Tier 0, the IR's promotion, the assembler, unwind tables, metadata).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker's area gate, C12c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
P=$D/../c3pr
mkdir -p logs compilers/again
cp compilers/compiler-areas0 compilers/again/compiler-areas0
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
groups=("10 11 12 13 14 21" "15 16 17 18 19 20" "22 23 24 25 26 27 28" "roots areas")
out=/dev/shm/claude-2924-c12c
for g in "${!groups[@]}"; do
    BUILDS=(--build none "$D/compilers/compiler-areas0" --build none-again "$D/compilers/again/compiler-areas0")
    for b in ${groups[$g]}; do
        case $b in
            roots) BUILDS+=(--build roots "$D/compilers/compiler-areas252");;
            areas) BUILDS+=(--build areas "$D/compilers/compiler-areas$(( (1 << 29) - (1 << 10) ))");;
            *) BUILDS+=(--build bit$b "$D/compilers/compiler-areas$((1 << b))");;
        esac
    done
    for list in sqlite lua musl; do
        rm -rf "$out"; mkdir -p "$out"
        case $list in
            sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
            lua) args=(-c --lanes 1 "$lua"/*.c);;
            musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
        esac
        (cd "$out" && "$D/compilers/main" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
            -- time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-g$g-$list.log" 2>&1)
        echo "time g$g $list: $?" >> logs/gate-status.txt
    done
done
rm -rf "$out"
echo done >> logs/gate-status.txt
