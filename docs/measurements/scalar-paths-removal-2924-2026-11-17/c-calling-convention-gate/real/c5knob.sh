#!/bin/bash
# #2924 C5's gate on real compiles: one experiment build (main bd197b2a6 + c5knob.patch, experiment only) whose
# BUSTER_ABI_PATH=scalar sends the checker's three calling-convention calls to the twins. Counts each part's types and
# calls over sqlite3.c, Lua and musl (BUSTER_ABI_COUNT, untimed), compares the objects of both settings, then times
# -c of the three lists with time-runs, the settings alternating over six rounds, each run under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the calling convention's real-compile gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p logs
if [ ! -d src ]; then git clone -q https://github.com/buster14a/buster src || exit 1; fi
git -C src fetch -q origin main && git -C src checkout -q --detach bd197b2a6 && git -C src apply "$D/c5knob.patch" || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compiler-knob
sha256sum compiler-knob > logs/compiler.sha256
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
out=/dev/shm/claude-2924-c5knob
rm -rf "$out"
for setting in vector scalar; do
    mkdir -p "$out/$setting/sqlite" "$out/$setting/lua" "$out/$setting/musl"
    (cd "$out/$setting/sqlite" && BUSTER_ABI_PATH=$setting BUSTER_ABI_COUNT=1 $L timeout -k 5 900 "$D/compiler-knob" -c --lanes 1 "${S[@]}" -o sqlite3.o 2> "$D/logs/count-sqlite-$setting.txt"); echo "objects sqlite $setting: $?" >> logs/status.txt
    (cd "$out/$setting/lua" && BUSTER_ABI_PATH=$setting BUSTER_ABI_COUNT=1 $L timeout -k 5 900 "$D/compiler-knob" -c --lanes 1 "$lua"/*.c 2> "$D/logs/count-lua-$setting.txt"); echo "objects lua $setting: $?" >> logs/status.txt
    (cd "$out/$setting/musl" && BUSTER_ABI_PATH=$setting BUSTER_ABI_COUNT=1 $L timeout -k 5 1500 "$D/compiler-knob" -c --lanes 1 "${M[@]}" "${files[@]}" 2> "$D/logs/count-musl-$setting.txt" > /dev/null); echo "objects musl $setting: $?" >> logs/status.txt
done
(cd "$out/vector" && find . -name '*.o' | sort) > logs/objects-list.txt
n=0; d=0
while read -r f; do n=$((n+1)); cmp -s "$out/vector/$f" "$out/scalar/$f" || { d=$((d+1)); echo "differs: $f" >> logs/objects-compare.txt; }; done < logs/objects-list.txt
echo "objects: $n compared, $d differ" >> logs/status.txt
rm -rf "$out"
t=/dev/shm/claude-2924-c5knob-time
for round in 1 2 3 4 5 6; do
    for setting in vector scalar; do
        if [ $(( round % 2 )) -eq 0 ]; then [ $setting = vector ] && setting=scalar || setting=vector; fi
        rm -rf "$t"; mkdir -p "$t"
        (cd "$t" && BUSTER_ABI_PATH=$setting $L timeout -k 5 1500 taskset -c 2 "$D/compiler-knob" time-runs --runs 3 --copies 3 --directory "$t" --build $setting "$D/compiler-knob" \
            --list -c --lanes 1 "${S[@]}" -o "$t/sqlite3.o" \
            --list -c --lanes 1 "$lua"/*.c \
            --list -c --lanes 1 "${M[@]}" "${files[@]}" > "$D/logs/time-$round-$setting.log" 2>&1)
        echo "time $round $setting: $?" >> logs/status.txt
    done
done
rm -rf "$t"
date -u +%FT%TZ > logs/.done
