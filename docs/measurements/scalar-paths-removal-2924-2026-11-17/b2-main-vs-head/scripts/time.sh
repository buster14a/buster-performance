#!/bin/bash
# #2924 phase B2's PR measurement, step 2: whole drivers, main against the head (Release), on the 9700X job's frozen corpus
# (sqlite3.c with the compile_time options, Lua 5.4.8's 34 sources, musl's 1,336 units as census.sh of
# node-machine-census-2524 took them). One lane each, CPU 2, objects to /dev/shm. ab takes the lock per round.
set -euo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: B2 main vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$D/../2924-claude/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
{
    sha256sum compilers/* "$sqlite/sqlite3.c" "$lua"/*.c
    echo "musl units ${#files[@]}"
    cat "${files[@]}" | sha256sum
} > logs/inputs.txt
out=/dev/shm/claude-2924-b2
rm -rf "$out"; mkdir -p "$out/lua" "$out/musl"
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(--build main "$D/compilers/main" --build head "$D/compilers/head" --build main-again "$D/compilers/main")
cd "$out"
"$D/compilers/main" ab --rounds "${ROUNDS:-3}" --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
    -- time-runs --runs "${RUNS:-3}" --copies 3 --directory "$out" "${B[@]}" \
    --list -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    --list -fsyntax-only --lanes 1 "${S[@]}" \
    --list -c --lanes 1 "$lua"/*.c \
    --list -c --lanes 1 "${M[@]}" "${files[@]}" \
    > "$D/logs/time.log" 2>&1
date -u +%FT%TZ > "$D/logs/.timed"
