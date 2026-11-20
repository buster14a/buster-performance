#!/bin/bash
# #2924 C12c-3: the validator's scalar twin, which only --verify (or a graph without its recorded facts) reaches. The split's
# knob tree (c12k-split/src-split: main 1962b1f73 with c12c-areas-knob.patch, c_checker.c's knobs at bit 29) copied, the
# validator's knob alone moved to bit 0 (unused). One Release build; every timed build a hard link to one fresh copy of it.
# 1. -c --lanes 1 --verify of sqlite3.c, Lua's units and musl's units by no bit and bit 0, objects compared.
# 2. ab, three rounds, around time-runs (three runs) of no bit, bit 0 and no bit again, -c --lanes 1 --verify, CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the validator under --verify, C12c-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
: > logs/status.txt
rm -rf src-verify
rsync -a --exclude build ../c12k-split/src-split/ src-verify/ || { echo "copy failed" >> logs/status.txt; exit 1; }
c=src-verify/src/buster/compiler
before=$(grep -c 'buster_scalar_area(29))) ? check_graph_validate(graph' $c/c_checker.c)
sed -i 's/BUSTER_SCALAR_PATH((options->scalar || buster_scalar_area(29))) ? check_graph_validate(graph/BUSTER_SCALAR_PATH((options->scalar || buster_scalar_area(0))) ? check_graph_validate(graph/' $c/c_checker.c
echo "validator knob lines: $before before, $(grep -c 'buster_scalar_area(0)' $c/c_checker.c) at bit 0" >> logs/status.txt
grep -n 'buster_scalar_area(0)' $c/c_checker.c >> logs/status.txt
(cd src-verify && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
echo "built" >> logs/status.txt
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$D/../c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
exe=/dev/shm/claude-2924-c12k-verify-exe
rm -rf "$exe"; mkdir -p "$exe/m0" "$exe/m1" "$exe/again"
cp src-verify/build/compiler "$exe/file"; cat "$exe/file" > /dev/null
ln "$exe/file" "$exe/m0/compiler-areas0"; ln "$exe/file" "$exe/m1/compiler-areas1"; ln "$exe/file" "$exe/again/compiler-areas0"
out=/dev/shm/claude-2924-c12k-verify
for m in 0 1; do
    for list in sqlite lua musl; do
        o=$out-objects/m$m/$list; rm -rf "$o"; mkdir -p "$o"
        case $list in
            sqlite) args=(-c --lanes 1 --verify "${S[@]}" -o sqlite3.o);;
            lua) args=(-c --lanes 1 --verify "$lua"/*.c);;
            musl) args=(-c --lanes 1 --verify "${M[@]}" "${files[@]}");;
        esac
        (cd "$o" && $L timeout -k 5 1500 taskset -c 2 "$exe/m$m/compiler-areas$m" "${args[@]}" > /dev/null 2> "$o.err"); echo "objects m$m $list: $?" >> logs/status.txt
    done
done
n=0; d=0
while read -r f; do n=$((n+1)); cmp -s "$out-objects/m0/$f" "$out-objects/m1/$f" || d=$((d+1)); done < <(cd "$out-objects/m0" && find . -name '*.o' | sort)
echo "objects --verify bit 0 against no bit: $n compared, $d differ" >> logs/status.txt
rm -rf "$out-objects"
BUILDS=(--build none "$exe/m0/compiler-areas0" --build bit0 "$exe/m1/compiler-areas1" --build none-again "$exe/again/compiler-areas0")
for list in sqlite lua musl; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 --verify "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 --verify "$lua"/*.c);;
        musl) args=(-c --lanes 1 --verify "${M[@]}" "${files[@]}");;
    esac
    (cd "$out" && "$exe/file" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$exe/file" \
        -- time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
rm -rf "$out" "$exe"
echo done >> logs/status.txt
