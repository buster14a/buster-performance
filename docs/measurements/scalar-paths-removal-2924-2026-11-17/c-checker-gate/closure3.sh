#!/bin/bash
# #2924 C12c's closure, third look: do the roots, the driver and the emission side's bits (26, 27, 28) reach the same as the areas? (the driver's
# own bit (21, the command's flag read where the driver uses it itself) reach the same as the areas?
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker's area gate, C12c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
P=$D/../c3pr
rd=$(( 252 | (1 << 21) | (1 << 26) | (1 << 27) | (1 << 28) ))
cp compilers/compiler-areas0 compilers/compiler-areas$rd
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
out=/dev/shm/claude-2924-c12c
BUILDS=(--build none "$D/compilers/compiler-areas0" --build bit26 "$D/compilers/compiler-areas$((1 << 26))" --build bit27 "$D/compilers/compiler-areas$((1 << 27))" --build bit28 "$D/compilers/compiler-areas$((1 << 28))" --build roots-driver-emission "$D/compilers/compiler-areas$rd"
        --build areas "$D/compilers/compiler-areas$(( (1 << 29) - (1 << 10) ))")
for list in sqlite lua musl; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
    esac
    (cd "$out" && "$D/compilers/main" ab --rounds 1 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
        -- time-runs --runs 1 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/closure3-$list.log" 2>&1)
    echo "closure3 $list: $?" >> logs/status.txt
done
rm -rf "$out"
echo done3 >> logs/status.txt
