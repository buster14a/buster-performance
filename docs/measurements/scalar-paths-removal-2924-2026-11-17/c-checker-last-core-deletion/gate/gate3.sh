#!/bin/bash
# #2924 C12c-3 core-3: the twins the driver's --scalar alone still selects in the checker's core. #3193's head
# (88741d83b, main 875980f24) with knob.diff: bit 0 the string literals' step (c_check_input.c's check_literal_strings_by),
# bit 1 the unsequenced checks' scans (check_unseq_marks, check_unseq_repeats), bit 2 the deferred merge's scans
# (check_deferred_entries, entries64, count_bytes, the expressions' copy and append), bit 3 the overload index's probe, bit
# 4 the mangling's scans, bit 5 the condition declarations' marks. One Release build; every timed build a hard link to
# one fresh copy of it.
# 1. Objects and stderr of every mask against no bit's: -c --lanes 1 of sqlite3.c, Lua's units and musl's units; -c
#    --lanes 4 --deferred-bodies of sqlite3.c and Lua's units; -c of the overloadable fixtures (gen.py, 1 to 256 groups).
# 2. ab, three rounds, around time-runs (three runs): no bit, bits 0, 1, both and no bit again on the three lists; no bit,
#    bit 2 and no bit again on the deferred lists; no bit, bits 3, 4, 5, all three and no bit again on each fixture.
# 3. musl's units below 8,000 preprocessed bytes, one locked time-runs --runs 9 each, of no bit, bit 0, bit 1, both and
#    no bit again.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's last twins' gate, C12c-3 core-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs fixtures
: > logs/status.txt
if [ ! -d src ]; then git clone -q --shared $D/../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
git -C src checkout -q --detach 88741d83b2952bd7cca22dc8fac2899becea51b4 && git -C src reset -q --hard && git -C src clean -qfd src
(cd src && git apply "$D/knob.diff") || { echo "apply failed" >> logs/status.txt; exit 1; }
echo "knob lines: $(grep -c 'buster_scalar_area(' src/src/buster/compiler/*.c | grep -v ':0$' | tr '\n' ' ')" >> logs/status.txt
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
echo "built" >> logs/status.txt
for n in 1 4 16 64 256; do python3 gen.py fixtures/overloadable-$n.c $n; done
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
DF=(--lanes 4 --deferred-bodies)
exe=/dev/shm/claude-2924-c12k3-exe
rm -rf "$exe"; mkdir -p "$exe"
cp src/build/compiler "$exe/file"; cat "$exe/file" > /dev/null
MASKS="0 1 2 3 4 8 16 32 56 63"
for m in $MASKS; do mkdir -p "$exe/m$m"; ln "$exe/file" "$exe/m$m/compiler-areas$m"; done
mkdir -p "$exe/again"; ln "$exe/file" "$exe/again/compiler-areas0"
out=/dev/shm/claude-2924-c12k3
objects=$out-objects
rm -rf "$objects"
LISTS="sqlite lua musl dsqlite dlua f1 f4 f16 f64 f256"
for m in $MASKS; do
    x="$exe/m$m/compiler-areas$m"
    for t in $LISTS; do
        cur=$objects/m$m/$t; mkdir -p "$cur"
        case $t in
            sqlite) a=(--lanes 1 "${S[@]}" -o sqlite3.o);;
            lua) a=(--lanes 1 "$lua"/*.c);;
            musl) a=(--lanes 1 "${M[@]}" "${files[@]}");;
            dsqlite) a=("${DF[@]}" "${S[@]}" -o sqlite3.o);;
            dlua) a=("${DF[@]}" "$lua"/*.c);;
            f*) a=(--lanes 1 "$D/fixtures/overloadable-${t#f}.c" -o fixture.o);;
        esac
        (cd "$cur" && $L timeout -k 5 1500 taskset -c 2 "$x" -c "${a[@]}" > /dev/null 2> "$objects/m$m/$t.err"); echo "objects m$m $t: $?" >> logs/status.txt
    done
done
for m in $MASKS; do
    [ "$m" = 0 ] && continue
    n=0; d=0
    while read -r f; do n=$((n+1)); cmp -s "$objects/m0/$f" "$objects/m$m/$f" || d=$((d+1)); done < <(cd "$objects/m0" && find . -name '*.o' | sort)
    e=0
    for t in $LISTS; do
        cmp -s <(grep -vE '^exclusive.sh: |^  (title|link): ' "$objects/m0/$t.err") <(grep -vE '^exclusive.sh: |^  (title|link): ' "$objects/m$m/$t.err") || e=$((e+1))
    done
    echo "m$m against no bit: $n objects, $d differ; stderr of 10 lists, $e differ" >> logs/status.txt
done
for t in $LISTS; do echo "stderr $t: $(grep -vcE '^exclusive.sh: |^  (title|link): ' "$objects/m0/$t.err") lines" >> logs/status.txt; done
rm -rf "$objects"
for list in sqlite lua musl dsqlite dlua f1 f4 f16 f64 f256; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o"); B=(--build none "$exe/m0/compiler-areas0" --build bit0 "$exe/m1/compiler-areas1" --build bit1 "$exe/m2/compiler-areas2" --build both "$exe/m3/compiler-areas3" --build none-again "$exe/again/compiler-areas0");;
        lua) args=(-c --lanes 1 "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
        dsqlite) args=(-c "${DF[@]}" "${S[@]}" -o "$out/sqlite3.o"); B=(--build none "$exe/m0/compiler-areas0" --build bit2 "$exe/m4/compiler-areas4" --build none-again "$exe/again/compiler-areas0");;
        dlua) args=(-c "${DF[@]}" "$lua"/*.c);;
        f1) args=(-c --lanes 1 "$D/fixtures/overloadable-1.c" -o "$out/fixture.o"); B=(--build none "$exe/m0/compiler-areas0" --build bit3 "$exe/m8/compiler-areas8" --build bit4 "$exe/m16/compiler-areas16" --build bit5 "$exe/m32/compiler-areas32" --build all3 "$exe/m56/compiler-areas56" --build none-again "$exe/again/compiler-areas0");;
        f*) args=(-c --lanes 1 "$D/fixtures/overloadable-${list#f}.c" -o "$out/fixture.o");;
    esac
    runs=3
    case $list in f*) runs=9;; esac
    (cd "$out" && "$exe/file" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$exe/file" \
        -- time-runs --runs $runs --directory "$out" "${B[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
: > logs/units.tsv
: > logs/runs.log
UB=(--build none "$exe/m0/compiler-areas0" --build bit0 "$exe/m1/compiler-areas1" --build bit1 "$exe/m2/compiler-areas2" --build both "$exe/m3/compiler-areas3" --build none-again "$exe/again/compiler-areas0")
i=0
while IFS=$'\t' read -r rel bytes rest; do
    [ "$bytes" -lt 8000 ] || continue
    f=$musl/$rel
    rm -rf "$out"; mkdir -p "$out"
    (cd "$out" && $L timeout -k 5 300 taskset -c 2 "$exe/file" time-runs --runs 9 --directory "$out" "${UB[@]}" --list -c --lanes 1 "${M[@]}" "$f" > "$D/logs/run.log" 2>&1)
    s=$?
    line=$(grep -E '^list 1 (none|bit0|bit1|both|none-again) \[' "$D/logs/run.log" | sed -E 's/^list 1 ([a-z0-9-]+) \[.*\]: .* ([0-9]+) user cycles, ([0-9]+) instructions$/\1 \2 \3/' | tr '\n' ' ')
    cat "$D/logs/run.log" >> "$D/logs/runs.log"
    printf '%s\t%s\t%s\t%s\n' "$rel" "$bytes" "$s" "$line" >> logs/units.tsv
    i=$((i+1))
done < "$D/../c12w-census/logs-u/units.tsv"
echo "units: $i" >> logs/status.txt
rm -rf "$out" "$exe"
echo done >> logs/status.txt
