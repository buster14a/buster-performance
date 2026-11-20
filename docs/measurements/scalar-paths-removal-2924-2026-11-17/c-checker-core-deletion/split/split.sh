#!/bin/bash
# #2924 C12c-3: the core area (C12c's bit 14, every checker file no other area names) split. The gate's knob tree
# (src-knob: main 1962b1f73 with c12c-areas-knob.patch) copied, its bit-14 knobs moved: c_checker.c's to bit 29, the
# initializers' (c_check_initializer.c, c_check_init_history.c) to bit 30, the attributes', the generic selections' and
# the static selections' (c_check_attribute.c, c_check_generic.c, c_check_select.c) to bit 31; the rest of the core stays
# bit 14. One Release build; every timed build is a hard link to one fresh copy of it, named for its mask.
# 1. ab, three rounds, around time-runs (three runs) of no bit, bits 14, 29, 30, 31, the four together, and no bit
#    again: -c --lanes 1 of sqlite3.c, Lua's units and musl's units, under the lock, CPU 2.
# 2. musl's units below 8,000 preprocessed bytes, one locked time-runs --runs 9 each, of no bit, bit 29, bit 30 and no
#    bit again (units3.sh's method).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
G=$D/../c12c
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's areas split, C12c-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
: > logs/status.txt
if [ ! -d src-split ]; then git clone -q --shared $G/src-knob src-split || exit 1; fi
git -C src-split checkout -q --detach 1962b1f73 && git -C src-split reset -q --hard
git -C $G/src-knob diff > knob.diff
(cd src-split && git apply knob.diff 2>/dev/null || git apply "$D/knob.diff") || { echo "apply failed" >> logs/status.txt; exit 1; }
c=src-split/src/buster/compiler
sed -i 's/buster_scalar_area(14)/buster_scalar_area(29)/g' $c/c_checker.c
sed -i 's/buster_scalar_area(14)/buster_scalar_area(30)/g' $c/c_check_initializer.c $c/c_check_init_history.c
sed -i 's/buster_scalar_area(14)/buster_scalar_area(31)/g' $c/c_check_attribute.c $c/c_check_generic.c $c/c_check_select.c
grep -c 'buster_scalar_area(29)\|buster_scalar_area(30)\|buster_scalar_area(31)' $c/c_checker.c $c/c_check_initializer.c $c/c_check_init_history.c $c/c_check_attribute.c $c/c_check_generic.c $c/c_check_select.c >> logs/status.txt
(cd src-split && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
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
exe=/dev/shm/claude-2924-c12k-exe
rm -rf "$exe"; mkdir -p "$exe"
cp src-split/build/compiler "$exe/file"; cat "$exe/file" > /dev/null
all=$(( (1 << 14) | (1 << 29) | (1 << 30) | (1 << 31) ))
for m in 0 $((1 << 14)) $((1 << 29)) $((1 << 30)) $((1 << 31)) $all; do mkdir -p "$exe/m$m"; ln "$exe/file" "$exe/m$m/compiler-areas$m"; done
mkdir -p "$exe/again"; ln "$exe/file" "$exe/again/compiler-areas0"
BUILDS=(--build none "$exe/m0/compiler-areas0" --build bit14 "$exe/m$((1 << 14))/compiler-areas$((1 << 14))" --build bit29 "$exe/m$((1 << 29))/compiler-areas$((1 << 29))"
        --build bit30 "$exe/m$((1 << 30))/compiler-areas$((1 << 30))" --build bit31 "$exe/m$((1 << 31))/compiler-areas$((1 << 31))" --build all "$exe/m$all/compiler-areas$all"
        --build none-again "$exe/again/compiler-areas0")
out=/dev/shm/claude-2924-c12k-split
for list in sqlite lua musl; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
    esac
    (cd "$out" && "$exe/file" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$exe/file" \
        -- time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
# 2. by unit size
: > logs/units.tsv
: > logs/runs.log
UB=(--build none "$exe/m0/compiler-areas0" --build bit29 "$exe/m$((1 << 29))/compiler-areas$((1 << 29))" --build bit30 "$exe/m$((1 << 30))/compiler-areas$((1 << 30))"
    --build none-again "$exe/again/compiler-areas0")
i=0
while IFS=$'\t' read -r rel bytes rest; do
    [ "$bytes" -lt 8000 ] || continue
    f=$musl/$rel
    rm -rf "$out"; mkdir -p "$out"
    (cd "$out" && $L timeout -k 5 300 taskset -c 2 "$exe/file" time-runs --runs 9 --directory "$out" "${UB[@]}" --list -c --lanes 1 "${M[@]}" "$f" > "$D/logs/run.log" 2>&1)
    s=$?
    line=$(grep -E '^list 1 (none|bit29|bit30|none-again) \[' "$D/logs/run.log" | sed -E 's/^list 1 ([a-z0-9-]+) \[.*\]: .* ([0-9]+) user cycles, ([0-9]+) instructions$/\1 \2 \3/' | tr '\n' ' ')
    cat "$D/logs/run.log" >> "$D/logs/runs.log"
    printf '%s\t%s\t%s\t%s\n' "$rel" "$bytes" "$s" "$line" >> logs/units.tsv
    i=$((i+1))
done < "$D/../c12w-census/logs-u/units.tsv"
rm -rf "$out" "$exe"
echo "units: $i" >> logs/status.txt
echo done >> logs/status.txt
