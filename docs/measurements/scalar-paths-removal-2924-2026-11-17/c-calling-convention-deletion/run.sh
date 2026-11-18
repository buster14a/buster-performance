#!/bin/bash
# #2924 C5, the calling convention's deletion: head (c5-calling-convention) against its base BASE on the 9700X: first
# the deletion's head 71f6caa16 against bd197b2a6 (main after #2952; logs-first-head/), then the final head against
# main 56e93bf02 (after #2954; logs/), Release, every run under the lock, timings on CPU 2. test-calling-convention --cross-check by
# head; benchmark-calling-convention, base (both paths) and head, three rounds; -c objects of sqlite3.c, Lua and musl by
# base and head, default and --scalar, compared byte by byte; whole-compile timings with ab around time-runs; the
# disassembly by function; the sections and the functions outside the start order.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the calling convention's deletion" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
BASE=${BASE:-56e93bf02}
mkdir -p compilers logs
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q $P/src-main src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side fetch -q "$D/c5del.bundle" "+refs/heads/c5-calling-convention:refs/heads/c5-calling-convention" || { echo "bundle failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach "$BASE"
git -C src-head checkout -q --detach c5-calling-convention
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
(cd src-head && $L timeout -k 5 1500 ../compilers/head test-calling-convention --cross-check > "$D/logs/test-calling-convention.log" 2>&1; echo "test-calling-convention --cross-check: $?" >> "$D/logs/status.txt")
(cd src-head && $L timeout -k 5 900 ../compilers/head test-calling-convention --seed 9 --count 600 > "$D/logs/test-calling-convention-seed9.log" 2>&1; echo "test-calling-convention seed 9: $?" >> "$D/logs/status.txt")
for round in 1 2 3; do
    $L timeout -k 5 900 taskset -c 2 ./compilers/base benchmark-calling-convention > logs/bench-base-$round.log 2>&1
    echo "bench base $round: $?" >> logs/status.txt
    $L timeout -k 5 900 taskset -c 2 ./compilers/head benchmark-calling-convention > logs/bench-head-$round.log 2>&1
    echo "bench head $round: $?" >> logs/status.txt
done
$L timeout -k 5 900 taskset -c 2 ./compilers/head benchmark-calling-convention --seed 7 --count 20000 > logs/bench-head-seed7.log 2>&1
echo "bench head seed 7: $?" >> logs/status.txt
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
objects=/dev/shm/claude-2924-c5del-objects
rm -rf "$objects"
for side in base head; do
    for mode in default scalar; do
        $L timeout -k 5 1500 "$D/objects.sh" "$D/compilers/$side" "$objects/$side-$mode" $mode > "logs/objects-$side-$mode.log" 2>&1
        echo "objects $side $mode: $(tr '\n' ' ' < logs/objects-$side-$mode.log)" >> logs/status.txt
    done
done
for mode in default scalar; do
    (cd "$objects/base-$mode" && find . -name '*.o' | sort) > logs/objects-list-$mode.txt
    n=0; d=0
    while read -r f; do
        n=$((n+1))
        cmp -s "$objects/base-$mode/$f" "$objects/head-$mode/$f" || { d=$((d+1)); echo "differs: $f" >> logs/objects-compare-$mode.txt; }
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
out=/dev/shm/claude-2924-c5del
rm -rf "$out"; mkdir -p "$out"
B=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
(cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${B[@]}" \
    --list -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    --list -fsyntax-only --lanes 1 "${S[@]}" \
    --list -c --lanes 1 "$lua"/*.c \
    --list -c --lanes 1 "${M[@]}" "${files[@]}" \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> logs/status.txt
rm -rf "$out"
for side in base head; do
    objdump -d --no-show-raw-insn compilers/$side > /dev/shm/claude-2924-c5del-$side.s && python3 disassembly/split.py /dev/shm/claude-2924-c5del-$side.s /dev/shm/claude-2924-c5del-$side.json
    rm -f /dev/shm/claude-2924-c5del-$side.s
done
python3 disassembly/compare.py /dev/shm/claude-2924-c5del-base.json /dev/shm/claude-2924-c5del-head.json > logs/compare.txt
rm -f /dev/shm/claude-2924-c5del-*.json
for side in base head; do
    readelf -sW compilers/$side | awk '$4 == "FUNC"' > logs/$side-functions.txt
    readelf -SW compilers/$side > logs/$side-sections.txt
done
date -u +%FT%TZ > logs/.done
