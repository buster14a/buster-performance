#!/bin/bash
# #2924 C12c-3 core-2: the sparse columns' scans (c_check_sparse.c's twins, which the attributes, the reader, the warnings,
# the bindings and the deferred expressions hand the flag on to), the generic and static selections, and the deprecated
# uses' scan. The PR head of #3186 (498b2f3a7, main eacca00de) with knob.diff: bit 0 the sparse scans, bit 1 the
# selections, bit 2 the deprecated uses. One Release build; every timed build a hard link to one fresh copy of it.
# 1. -c --lanes 1 -Wall -Wextra of sqlite3.c, Lua's units and musl's units by no bit and each bit, objects and stderr
#    compared with no bit's.
# 2. ab, three rounds, around time-runs (three runs) of no bit, bits 0, 1, 2, all three and no bit again: -c --lanes 1
#    of the three lists, by default and with -Wall -Wextra.
# 3. musl's units below 8,000 preprocessed bytes, one locked time-runs --runs 9 each, of no bit, bit 0, all three and no
#    bit again.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the sparse scans' gate, C12c-3 core-2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
: > logs/status.txt
if [ ! -d src ]; then git clone -q --shared $D/../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
git -C src checkout -q --detach 498b2f3a7d357de9a01c72aff6221d80ef925cdf && git -C src reset -q --hard && git -C src clean -qfd src
(cd src && git apply "$D/knob.diff") || { echo "apply failed" >> logs/status.txt; exit 1; }
echo "knob lines: $(grep -c buster_scalar_area src/src/buster/compiler/c_check_sparse.c src/src/buster/compiler/c_check_generic.c src/src/buster/compiler/c_check_select.c src/src/buster/compiler/c_check_attribute.c | tr '\n' ' ')" >> logs/status.txt
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
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
W=(-Wall -Wextra)
exe=/dev/shm/claude-2924-c12k2-exe
rm -rf "$exe"; mkdir -p "$exe"
cp src/build/compiler "$exe/file"; cat "$exe/file" > /dev/null
for m in 0 1 2 4 7; do mkdir -p "$exe/m$m"; ln "$exe/file" "$exe/m$m/compiler-areas$m"; done
mkdir -p "$exe/again"; ln "$exe/file" "$exe/again/compiler-areas0"
out=/dev/shm/claude-2924-c12k2
objects=$out-objects
rm -rf "$objects"
for m in 0 1 2 4 7; do
    cur=$objects/m$m; mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl"
    x="$exe/m$m/compiler-areas$m"
    (cd "$cur/sqlite" && $L timeout -k 5 1500 taskset -c 2 "$x" -c --lanes 1 "${W[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$cur/sqlite.err"); echo "objects m$m sqlite: $?" >> logs/status.txt
    (cd "$cur/lua" && $L timeout -k 5 1500 taskset -c 2 "$x" -c --lanes 1 "${W[@]}" "$lua"/*.c > /dev/null 2> "$cur/lua.err"); echo "objects m$m lua: $?" >> logs/status.txt
    (cd "$cur/musl" && $L timeout -k 5 1500 taskset -c 2 "$x" -c --lanes 1 "${W[@]}" "${M[@]}" "${files[@]}" > /dev/null 2> "$cur/musl.err"); echo "objects m$m musl: $?" >> logs/status.txt
done
for m in 1 2 4 7; do
    n=0; d=0
    while read -r f; do n=$((n+1)); cmp -s "$objects/m0/$f" "$objects/m$m/$f" || d=$((d+1)); done < <(cd "$objects/m0" && find . -name '*.o' | sort)
    e=0
    for t in sqlite lua musl; do
        cmp -s <(grep -vE '^exclusive.sh: |^  (title|link): ' "$objects/m0/$t.err") <(grep -vE '^exclusive.sh: |^  (title|link): ' "$objects/m$m/$t.err") || e=$((e+1))
    done
    echo "m$m against no bit: $n objects, $d differ; stderr of 3 lists, $e differ" >> logs/status.txt
done
for t in sqlite lua musl; do echo "stderr $t: $(grep -vcE '^exclusive.sh: |^  (title|link): ' "$objects/m0/$t.err") lines" >> logs/status.txt; done
rm -rf "$objects"
BUILDS=(--build none "$exe/m0/compiler-areas0" --build bit0 "$exe/m1/compiler-areas1" --build bit1 "$exe/m2/compiler-areas2" --build bit2 "$exe/m4/compiler-areas4"
        --build all "$exe/m7/compiler-areas7" --build none-again "$exe/again/compiler-areas0")
for list in sqlite lua musl sqlite-wall lua-wall musl-wall; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
        sqlite-wall) args=(-c --lanes 1 "${W[@]}" "${S[@]}" -o "$out/sqlite3.o");;
        lua-wall) args=(-c --lanes 1 "${W[@]}" "$lua"/*.c);;
        musl-wall) args=(-c --lanes 1 "${W[@]}" "${M[@]}" "${files[@]}");;
    esac
    (cd "$out" && "$exe/file" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$exe/file" \
        -- time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
: > logs/units.tsv
: > logs/runs.log
UB=(--build none "$exe/m0/compiler-areas0" --build bit0 "$exe/m1/compiler-areas1" --build all "$exe/m7/compiler-areas7" --build none-again "$exe/again/compiler-areas0")
i=0
while IFS=$'\t' read -r rel bytes rest; do
    [ "$bytes" -lt 8000 ] || continue
    f=$musl/$rel
    rm -rf "$out"; mkdir -p "$out"
    (cd "$out" && $L timeout -k 5 300 taskset -c 2 "$exe/file" time-runs --runs 9 --directory "$out" "${UB[@]}" --list -c --lanes 1 "${M[@]}" "$f" > "$D/logs/run.log" 2>&1)
    s=$?
    line=$(grep -E '^list 1 (none|bit0|all|none-again) \[' "$D/logs/run.log" | sed -E 's/^list 1 ([a-z0-9-]+) \[.*\]: .* ([0-9]+) user cycles, ([0-9]+) instructions$/\1 \2 \3/' | tr '\n' ' ')
    cat "$D/logs/run.log" >> "$D/logs/runs.log"
    printf '%s\t%s\t%s\t%s\n' "$rel" "$bytes" "$s" "$line" >> logs/units.tsv
    i=$((i+1))
done < "$D/../c12w-census/logs-u/units.tsv"
echo "units: $i" >> logs/status.txt
rm -rf "$out" "$exe"
echo done >> logs/status.txt
