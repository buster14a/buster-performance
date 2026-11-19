#!/bin/bash
# #2924 C12a's gate: the preprocessor's areas, each sent to its scalar arms alone, on C11a's head 22f3d4625 plus
# c12a-areas-knob.patch (EXPERIMENT ONLY: the executable takes its areas' bits from its file's name, compiler-areasN).
# Areas (bit k, mask 1<<k): 10 the files' preparation (splices, directives' tables and pairing, raw candidates, named
# UCNs, files_prepare), 11 lexing (pp_lex_for_mode, the tokenizer's dollar handling), 12 diagnostic lines, 13 macros
# (definitions, parameter indexes, pp_is_macro), 14 expansion (substitution, pasting, arguments, object expansion,
# direct conditions, line copies), 15 stepping (file and buffer runs, keywords, templates), 16 history, 17 printing and
# #embed's text, 18 the windowed preparation; all of them (523264); and a control bit no site reads (1 << 20).
# Release, every run under the lock on CPU 2:
# 1. -E of sqlite3.c, Lua's units and musl's units by every build, compared with no bit's byte by byte;
# 2. ab, three rounds, around time-runs of the twelve builds (three runs each), one list at a time: -E of sqlite3.c,
#    Lua's units and musl's units.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the preprocessor's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p logs compilers
if [ ! -d src ]; then git clone -q --shared $D/../c11pr/src-head src || exit 1; fi
git -C src checkout -q --detach 22f3d4625 && git -C src reset -q --hard
(cd src && patch -p1 < "$D/c12a-areas-knob.patch" > "$D/logs/patch.log" 2>&1) || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
names=(none prepare lex lines macros expansion step history print windows all control)
masks=(0 1024 2048 4096 8192 16384 32768 65536 131072 262144 523264 1048576)
for m in "${masks[@]}"; do cp src/build/compiler compilers/compiler-areas$m; done
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
out=/dev/shm/claude-2924-c12a-outputs
rm -rf "$out"; mkdir -p "$out"
for i in "${!masks[@]}"; do
    exe="$D/compilers/compiler-areas${masks[$i]}"
    $L timeout -k 5 900 "$exe" -E "${S[@]}" -o "$out/${names[$i]}-sqlite.i" 2>> "$D/logs/stderr-${names[$i]}.txt"; echo "output ${names[$i]} sqlite: $?" >> logs/status.txt
    $L timeout -k 5 900 bash -c '"$0" -E "$@"' "$exe" "$lua"/*.c > "$out/${names[$i]}-lua.i" 2>> "$D/logs/stderr-${names[$i]}.txt"; echo "output ${names[$i]} lua: $?" >> logs/status.txt
    $L timeout -k 5 900 bash -c '"$0" -E "$@"' "$exe" "${M[@]}" "${files[@]}" > "$out/${names[$i]}-musl.i" 2>> "$D/logs/stderr-${names[$i]}.txt"; echo "output ${names[$i]} musl: $?" >> logs/status.txt
done
for i in "${!masks[@]}"; do
    for list in sqlite lua musl; do
        cmp -s "$out/none-$list.i" "$out/${names[$i]}-$list.i"; echo "same output ${names[$i]} $list: $? ($(wc -c < "$out/${names[$i]}-$list.i") bytes)" >> logs/status.txt
    done
done
rm -rf "$out"
time=/dev/shm/claude-2924-c12a
BUILDS=()
for i in "${!masks[@]}"; do BUILDS+=(--build "${names[$i]}" "$D/compilers/compiler-areas${masks[$i]}"); done
for list in sqlite lua musl; do
    rm -rf "$time"; mkdir -p "$time"
    case $list in
        sqlite) args=(-E "${S[@]}" -o "$time/sqlite3.i");;
        lua) args=(-E "$lua"/*.c);;
        musl) args=(-E "${M[@]}" "${files[@]}");;
    esac
    (cd "$time" && "$D/compilers/compiler-areas0" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/compiler-areas0" \
        -- time-runs --runs 3 --directory "$time" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
rm -rf "$time"
echo done >> logs/status.txt
date -u +%FT%TZ > logs/.done
