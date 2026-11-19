#!/bin/bash
# #2924 C12c: which root lowers the areas' instructions? time-runs --runs 1 of the areas with one root each (exact
# instruction counts), on the list given ($1: sqlite, lua or musl), under the lock on CPU 2. Masks from $2... .
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker's area gate, C12c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
P=$D/../c3pr
list=$1; shift
tag=$1; shift
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
mkdir -p compilers/bisect
BUILDS=()
for mask in "$@"; do
    [ -e compilers/bisect/compiler-areas$mask ] || cp compilers/compiler-areas0 compilers/bisect/compiler-areas$mask
    BUILDS+=(--build m$mask "$D/compilers/bisect/compiler-areas$mask")
done
out=/dev/shm/claude-2924-c12c-bisect
rm -rf "$out"; mkdir -p "$out"
case $list in
    sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
    lua) args=(-c --lanes 1 "$lua"/*.c);;
    musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
esac
(cd "$out" && "$D/compilers/main" ab --rounds 1 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
    -- time-runs --runs 1 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/bisect-$tag-$list.log" 2>&1)
rm -rf "$out"
grep -P '^list \d+ ' "$D/logs/bisect-$tag-$list.log" | sed -E 's/ \[.*\]:/:/' | grep -oP '^list \d+ \w+|\d+ instructions' | paste - - > "$D/logs/bisect-$tag-$list.txt"
echo "done $tag" >> logs/bisect-status.txt
