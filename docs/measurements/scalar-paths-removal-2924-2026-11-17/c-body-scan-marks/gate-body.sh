#!/bin/bash
# #2924 C12a's rest: pp_define's body scan. One experiment executable (main 968a085f + body-knob.patch, EXPERIMENT ONLY)
# whose file name selects the scan: compiler-areas0 the vector arm, -areas1 the scalar arm, -areas2 the marks (which
# preparation then makes), -areas4 a control bit no site reads. Every timed build is a hard link to one fresh copy.
# Every run under the lock on CPU 2: -E outputs of musl's units, Lua's units and sqlite3.c compared across arms; then
# ab, three rounds, around time-runs (three runs each) of the four, one list at a time.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
. ~/buster-fast-bench/2924-asm-pp-claude/env.sh
L=$EX
mkdir -p gate/logs
if [ ! -d gate/src ]; then git clone -q --shared $W/src gate/src || exit 1; fi
git -C gate/src checkout -q --detach 968a085f && git -C gate/src reset -q --hard && git -C gate/src clean -qfd src
(cd gate/src && git apply "$D/body-knob.patch" > "$D/gate/logs/patch.log" 2>&1) || { echo "patch failed" >> gate/logs/status.txt; exit 1; }
(cd gate/src && $L timeout -k 5 900 ./build.sh --config Release > "$D/gate/logs/build.log" 2>&1) || { echo "build failed" >> gate/logs/status.txt; exit 1; }
rm -rf gate/compilers; mkdir -p gate/compilers
cp gate/src/build/compiler gate/compilers/base
for m in 0 1 2 4; do ln gate/compilers/base gate/compilers/compiler-areas$m; done
P=~/buster-fast-bench/2924-c-df-claude/c3pr
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
out=/dev/shm/claude-2924-body-out
for list in musl lua sqlite; do
    case $list in
        sqlite) args=("${S[@]}");;
        lua) args=("$lua"/*.c);;
        musl) args=("${M[@]}" "${files[@]}");;
    esac
    rm -rf "$out"; mkdir -p "$out"
    for m in 0 1 2; do
        $L timeout -k 5 600 bash -c '"$0" -E "$@"' "$D/gate/compilers/compiler-areas$m" "${args[@]}" > "$out/$m.i" 2> "$out/$m.err"; echo "output $m $list: $?" >> gate/logs/status.txt
    done
    for m in 1 2; do
        cmp -s "$out/0.i" "$out/$m.i" && cmp -s <(grep -v '^exclusive.sh\|^  title:\|^  link:\|^    ' "$out/0.err") <(grep -v '^exclusive.sh\|^  title:\|^  link:\|^    ' "$out/$m.err"); echo "same $list 0-$m: $?" >> gate/logs/status.txt
    done
    wc -c "$out"/0.i "$out"/0.err >> gate/logs/status.txt
done
rm -rf "$out"
time=/dev/shm/claude-2924-body-time
C=$D/gate/compilers
BUILDS=(--build vector "$C/compiler-areas0" --build scalar "$C/compiler-areas1" --build marks "$C/compiler-areas2" --build control "$C/compiler-areas4")
for list in musl lua sqlite; do
    rm -rf "$time"; mkdir -p "$time"
    case $list in
        sqlite) args=(-E "${S[@]}" -o "$time/sqlite3.i");;
        lua) args=(-E "$lua"/*.c);;
        musl) args=(-E "${M[@]}" "${files[@]}");;
    esac
    (cd "$time" && "$C/compiler-areas0" ab --rounds 3 --cpu 2 --lock $L "$C/compiler-areas0" \
        -- time-runs --runs 3 --directory "$time" "${BUILDS[@]}" --list "${args[@]}" > "$D/gate/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> gate/logs/status.txt
done
rm -rf "$time"
echo done >> gate/logs/status.txt
date -u +%FT%TZ > gate/logs/.done
