#!/bin/bash
# #2924 C3 / #2950 PR on the 9700X: main aa09d1a04 against head b9400e212, Release, each run under the lock on CPU 2:
# benchmark-dataflow, three alternating processes each; IR dataflow's benchmark on sqlite3.c (head; its scalar twin is
# the comparison); test-dataflow and the IR dataflow self-test on the head; -c and -fsyntax-only of sqlite3.c, Lua and
# musl with ab around time-runs (main, head, main-again); the disassembly by function; the head's start-order section.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Dataflow #2950: the PR, main against head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2950
L=~/buster-fast-bench/exclusive.sh
mkdir -p compilers logs inputs
[ -d inputs/lua-5.4.8 ] || cp -r ~/buster-fast-bench/138-tier1-cost-claude/inputs/lua-5.4.8 inputs/
for side in main head; do
    rev=aa09d1a04; [ $side = head ] && rev=b9400e212
    if [ ! -d src-$side ]; then git clone -q https://github.com/buster14a/buster src-$side || exit 1; fi
    git -C src-$side fetch -q origin main claude/wonderful-wozniak-vbfba7 && git -C src-$side checkout -q --detach $rev || { echo "checkout $side failed" >> logs/status.txt; exit 1; }
    git -C src-$side rev-parse HEAD >> logs/commits.txt
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
for round in 1 2 3; do
    for side in main head; do
        $L timeout -k 5 900 taskset -c 2 ./compilers/$side benchmark-dataflow > logs/bench-$side-$round.log 2>&1
        echo "bench $side $round: $?" >> logs/status.txt
    done
done
(cd src-head && $L timeout -k 5 900 ../compilers/head test-dataflow > "$D/logs/test-dataflow.log" 2>&1; echo "test-dataflow: $?" >> "$D/logs/status.txt")
(cd src-head && $L timeout -k 5 900 ../compilers/head test-ir-source --dataflow-self-test > "$D/logs/test-ir-dataflow-self.log" 2>&1; echo "ir self-test: $?" >> "$D/logs/status.txt")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$D/inputs/lua-5.4.8/src
(cd src-head && $L timeout -k 5 1500 taskset -c 2 ../compilers/head test-ir-source --dataflow-benchmark --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$sqlite/sqlite3.c" > "$D/logs/ir-sqlite-head.log" 2>&1)
echo "ir sqlite head: $?" >> logs/status.txt
xz -9 -T2 logs/ir-sqlite-head.log
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
{
    sha256sum compilers/* "$sqlite/sqlite3.c" "$lua"/*.c
    echo "musl units ${#files[@]}"
    cat "${files[@]}" | sha256sum
} > logs/inputs.txt
out=/dev/shm/claude-2924-df
rm -rf "$out"; mkdir -p "$out/lua" "$out/musl"
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
B=(--build main "$D/compilers/main" --build head "$D/compilers/head" --build main-again "$D/compilers/main")
(cd "$out" && "$D/compilers/main" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${B[@]}" \
    --list -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    --list -fsyntax-only --lanes 1 "${S[@]}" \
    --list -c --lanes 1 "$lua"/*.c \
    --list -c --lanes 1 "${M[@]}" "${files[@]}" \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> logs/status.txt
rm -rf "$out"
for side in main head; do
    objdump -d --no-show-raw-insn compilers/$side > /dev/shm/claude-2924-df-$side.s && python3 disassembly/split.py /dev/shm/claude-2924-df-$side.s logs/$side.json
    rm -f /dev/shm/claude-2924-df-$side.s
done
python3 disassembly/compare.py logs/main.json logs/head.json > logs/compare.txt
readelf -sW compilers/head | awk '$4 == "FUNC"' > logs/head-functions.txt
readelf -SW compilers/head > logs/head-sections.txt
date -u +%FT%TZ > logs/.done
