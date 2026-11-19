#!/bin/bash
# #2924 C12b's gate, the timings again: time-runs without --copies, whose copies (DIRECTORY/EEE-CCC) lose the
# "-areasN" name the knob reads. The executables are run.sh's (compilers/compiler-areasN), each run under the lock on
# CPU 2, ab's three rounds.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the parser's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
P=$D/../c3pr
names=(none whole handoff scopes gnu all control)
masks=(0 1048576 2097152 4194304 8388608 15728640 16777216)
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
time=/dev/shm/claude-2924-c12b
BUILDS=()
for i in "${!masks[@]}"; do BUILDS+=(--build "${names[$i]}" "$D/compilers/compiler-areas${masks[$i]}"); done
mkdir -p logs2
for list in parse-sqlite parse-buster syntax-lua syntax-musl c-sqlite c-musl; do
    rm -rf "$time"; mkdir -p "$time"
    case $list in
        parse-sqlite) args=(parse -fsyntax-only "${S[@]}");;
        parse-buster) args=(parse -fsyntax-only -march=znver5 -I"$D/src/src" -fwrapv -funsigned-char --predefines "$D/predefines.h" -DBUSTER_COMPLETE_DRIVER=1 "$D/src/src/buster/compiler/main.c");;
        syntax-lua) args=(-fsyntax-only "$lua"/*.c);;
        syntax-musl) args=(-fsyntax-only "${M[@]}" "${files[@]}");;
        c-sqlite) args=(-c --lanes 1 "${S[@]}" -o "$time/sqlite3.o");;
        c-musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
    esac
    (cd "$time" && "$D/compilers/compiler-areas0" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/compiler-areas0" \
        -- time-runs --runs 3 --directory "$time" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs2/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs2/status.txt
done
rm -rf "$time"
echo done >> logs2/status.txt
