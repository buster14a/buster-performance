#!/bin/bash
# #2924 C3, the deletion (head2, on #2951's head b9400e212) against main aa09d1a04 on the 9700X, Release, each run under
# the lock on CPU 2: benchmark-dataflow (seed 1 checks the frozen digests and counts) three alternating processes, and
# seed 2 once; test-dataflow and the IR dataflow self-test; IR dataflow's benchmark on sqlite3.c; -c objects of
# sqlite3.c, Lua and musl by main and head2, default and --scalar, compared byte by byte; -c and -fsyntax-only timings
# with ab around time-runs; the disassembly by function; the sections.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: dataflow's deletion" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p compilers logs
cp $P/compilers/main compilers/main
if [ ! -d src ]; then git clone -q $P/src-head src || exit 1; fi
git -C src fetch -q "$D/c3del.bundle" "+refs/heads/c3-delete:refs/heads/c3-delete" || { echo "bundle failed" >> logs/status.txt; exit 1; }
git -C src checkout -q --detach c3-delete
printf 'main aa09d1a04\nhead2 %s\n' "$(git -C src rev-parse HEAD)" > logs/commits.txt
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-head2.log" 2>&1) || { echo "build head2 failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compilers/head2
sha256sum compilers/* > logs/compilers.sha256
for round in 1 2 3; do
    for side in main head2; do
        $L timeout -k 5 900 taskset -c 2 ./compilers/$side benchmark-dataflow > logs/bench-$side-$round.log 2>&1
        echo "bench $side $round: $?" >> logs/status.txt
    done
done
$L timeout -k 5 900 taskset -c 2 ./compilers/head2 benchmark-dataflow --seed 2 > logs/bench-head2-seed2.log 2>&1
echo "bench head2 seed 2: $?" >> logs/status.txt
(cd src && $L timeout -k 5 900 ../compilers/head2 test-dataflow > "$D/logs/test-dataflow.log" 2>&1; echo "test-dataflow: $?" >> "$D/logs/status.txt")
(cd src && $L timeout -k 5 900 ../compilers/head2 test-ir-source --dataflow-self-test > "$D/logs/test-ir-dataflow-self.log" 2>&1; echo "ir self-test: $?" >> "$D/logs/status.txt")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
(cd src && $L timeout -k 5 1500 taskset -c 2 ../compilers/head2 test-ir-source --dataflow-benchmark --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$sqlite/sqlite3.c" > "$D/logs/ir-sqlite-head2.log" 2>&1)
echo "ir sqlite head2: $?" >> logs/status.txt
xz -9 -T2 logs/ir-sqlite-head2.log
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
objects=/dev/shm/claude-2924-c3del-objects
rm -rf "$objects"
for side in main head2; do
    for mode in default scalar; do
        $L timeout -k 5 1500 "$D/objects.sh" "$D/compilers/$side" "$objects/$side-$mode" $mode > "logs/objects-$side-$mode.log" 2>&1
        echo "objects $side $mode: $(tr '\n' ' ' < logs/objects-$side-$mode.log)" >> logs/status.txt
    done
done
for mode in default scalar; do
    (cd "$objects/main-$mode" && find . -name '*.o' | sort) > logs/objects-list-$mode.txt
    n=0; d=0
    while read -r f; do
        n=$((n+1))
        cmp -s "$objects/main-$mode/$f" "$objects/head2-$mode/$f" || { d=$((d+1)); echo "differs: $f" >> logs/objects-compare-$mode.txt; }
    done < logs/objects-list-$mode.txt
    echo "objects $mode: $n compared, $d differ" >> logs/objects-compare-$mode.txt
    echo "objects $mode: $n compared, $d differ" >> logs/status.txt
done
rm -rf "$objects"
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
{
    sha256sum compilers/* "$sqlite/sqlite3.c" "$lua"/*.c
    echo "musl units ${#files[@]}"
    cat "${files[@]}" | sha256sum
} > logs/inputs.txt
out=/dev/shm/claude-2924-c3del
rm -rf "$out"; mkdir -p "$out"
B=(--build main "$D/compilers/main" --build head2 "$D/compilers/head2" --build main-again "$D/compilers/main")
(cd "$out" && "$D/compilers/main" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${B[@]}" \
    --list -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    --list -fsyntax-only --lanes 1 "${S[@]}" \
    --list -c --lanes 1 "$lua"/*.c \
    --list -c --lanes 1 "${M[@]}" "${files[@]}" \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> logs/status.txt
rm -rf "$out"
for side in main head2; do
    objdump -d --no-show-raw-insn compilers/$side > /dev/shm/claude-2924-c3del-$side.s && python3 disassembly/split.py /dev/shm/claude-2924-c3del-$side.s /dev/shm/claude-2924-c3del-$side.json
    rm -f /dev/shm/claude-2924-c3del-$side.s
done
python3 disassembly/compare.py /dev/shm/claude-2924-c3del-main.json /dev/shm/claude-2924-c3del-head2.json > logs/compare.txt
rm -f /dev/shm/claude-2924-c3del-*.json
readelf -sW compilers/head2 | awk '$4 == "FUNC"' > logs/head2-functions.txt
readelf -SW compilers/head2 > logs/head2-sections.txt
date -u +%FT%TZ > logs/.done
