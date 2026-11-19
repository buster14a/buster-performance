#!/bin/bash
# #2924 C12a's gate: pp_define's body scan (area 21) read 0.7% to 1.5% faster by its scalar arm on musl's units.
# c12a-scan-knob.patch makes the vector scan branch-free (all four quarters' value loads, each masked to its
# identifiers). Every run under the lock on CPU 2: -E outputs compared; ab, three rounds, around time-runs of the new
# build's copies (none, area 21's scalar arm, a control bit) and macros.sh's (none, area 21), on -E of musl's units, Lua's
# units and sqlite3.c.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the preprocessor's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p scan/logs scan/compilers
if [ ! -d scan/src ]; then git clone -q --shared $D/../c11pr/src-head scan/src || exit 1; fi
git -C scan/src checkout -q --detach 22f3d4625 && git -C scan/src reset -q --hard
(cd scan/src && patch -p1 < "$D/c12a-scan-knob.patch" > "$D/scan/logs/patch.log" 2>&1) || { echo "patch failed" >> scan/logs/status.txt; exit 1; }
(cd scan/src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/scan/logs/build.log" 2>&1) || { echo "build failed" >> scan/logs/status.txt; exit 1; }
for m in 0 2097152 4194304; do cp scan/src/build/compiler scan/compilers/compiler-areas$m; done
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
out=/dev/shm/claude-2924-c12a-scan
rm -rf "$out"; mkdir -p "$out"
for m in 0 2097152; do
    $L timeout -k 5 900 bash -c '"$0" -E "$@"' "$D/scan/compilers/compiler-areas$m" "${M[@]}" "${files[@]}" > "$out/$m-musl.i" 2>> "$D/scan/logs/stderr.txt"; echo "output $m musl: $?" >> scan/logs/status.txt
done
$L timeout -k 5 900 bash -c '"$0" -E "$@"' "$D/macros/compilers/compiler-areas0" "${M[@]}" "${files[@]}" > "$out/old-musl.i" 2>> "$D/scan/logs/stderr.txt"; echo "output old musl: $?" >> scan/logs/status.txt
cmp -s "$out/old-musl.i" "$out/0-musl.i"; echo "same output new musl: $?" >> scan/logs/status.txt
cmp -s "$out/old-musl.i" "$out/2097152-musl.i"; echo "same output new-define musl: $?" >> scan/logs/status.txt
rm -rf "$out"
time=/dev/shm/claude-2924-c12a-scan-time
BUILDS=(--build new "$D/scan/compilers/compiler-areas0" --build new-scalar-scan "$D/scan/compilers/compiler-areas2097152" --build new-control "$D/scan/compilers/compiler-areas4194304"
        --build old "$D/macros/compilers/compiler-areas0" --build old-scalar-scan "$D/macros/compilers/compiler-areas2097152")
for list in musl lua sqlite; do
    rm -rf "$time"; mkdir -p "$time"
    case $list in
        sqlite) args=(-E "${S[@]}" -o "$time/sqlite3.i");;
        lua) args=(-E "$lua"/*.c);;
        musl) args=(-E "${M[@]}" "${files[@]}");;
    esac
    (cd "$time" && "$D/scan/compilers/compiler-areas0" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/scan/compilers/compiler-areas0" \
        -- time-runs --runs 3 --directory "$time" "${BUILDS[@]}" --list "${args[@]}" > "$D/scan/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> scan/logs/status.txt
done
rm -rf "$time"
echo done >> scan/logs/status.txt
date -u +%FT%TZ > scan/logs/.done
