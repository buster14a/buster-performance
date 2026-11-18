#!/bin/bash
# #2924 C7b, Tier 1's selection twins deleted: head (branch c7b-final from c7b.bundle) against its base BASE on the
# 9700X, Release, every run under the lock, timings on CPU 2.
# 1. test-tier1-select and test-tier1-pipeline --cross-check by head;
# 2. benchmark-tier1-select-source on the frozen sqlite3.c, three rounds: base's select row against head's;
#    benchmark-tier1-select --only vector, three rounds each;
# 3. --tier1 -c objects of sqlite3.c, Lua and musl by base and head, every compile in one directory, byte by byte;
# 4. whole compiles, ab around time-runs: --tier1 -c of sqlite3.c and of Lua's units.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's selection" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
BASE=${BASE:?}
mkdir -p compilers logs
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q --shared $D/../c7gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side fetch -q "$D/c7b.bundle" "+refs/heads/c7b-final:refs/heads/c7b-final" || { echo "bundle failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach "$BASE" && git -C src-base reset -q --hard
git -C src-head checkout -q --detach c7b-final && git -C src-head reset -q --hard
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
(cd src-head && $L timeout -k 5 1500 ../compilers/head test-tier1-select > "$D/logs/test-tier1-select.log" 2>&1; echo "test-tier1-select: $?" >> "$D/logs/status.txt")
(cd src-head && $L timeout -k 5 1500 ../compilers/head test-tier1-pipeline --cross-check > "$D/logs/test-tier1-pipeline.log" 2>&1; echo "test-tier1-pipeline --cross-check: $?" >> "$D/logs/status.txt")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
F=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$sqlite/sqlite3.c")
for round in 1 2 3; do
    $L timeout -k 5 900 taskset -c 2 ./compilers/base benchmark-tier1-select-source --only select "${F[@]}" > logs/source-base-$round.log 2>&1
    echo "source base $round: $?" >> logs/status.txt
    $L timeout -k 5 900 taskset -c 2 ./compilers/head benchmark-tier1-select-source "${F[@]}" > logs/source-head-$round.log 2>&1
    echo "source head $round: $?" >> logs/status.txt
    for side in base head; do
        $L timeout -k 5 900 taskset -c 2 ./compilers/$side benchmark-tier1-select --only vector > logs/select-$side-$round.log 2>&1
        echo "select $side $round: $?" >> logs/status.txt
    done
done
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
objects=/dev/shm/claude-2924-c7b-objects
rm -rf "$objects"
for side in base head; do
    cur=$objects/cur
    mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl"
    (cd "$cur/sqlite" && $L timeout -k 5 1500 "$D/compilers/$side" -c --tier1 --lanes 1 "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr-$side.txt"); echo "objects $side sqlite: $?" >> logs/status.txt
    (cd "$cur/lua" && $L timeout -k 5 1500 "$D/compilers/$side" -c --tier1 --lanes 1 "$lua"/*.c > /dev/null 2>> "$D/logs/stderr-$side.txt"); echo "objects $side lua: $?" >> logs/status.txt
    (cd "$cur/musl" && $L timeout -k 5 1500 "$D/compilers/$side" -c --tier1 --lanes 1 "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr-$side.txt"); echo "objects $side musl: $?" >> logs/status.txt
    mv "$cur" "$objects/$side"
done
n=0; d=0
while read -r f; do
    n=$((n+1))
    cmp -s "$objects/base/$f" "$objects/head/$f" || { d=$((d+1)); echo "differs: $f" >> logs/objects-compare.txt; }
done < <(cd "$objects/base" && find . -name '*.o' | sort)
echo "objects: $n compared, $d differ" >> logs/status.txt
rm -rf "$objects"
out=/dev/shm/claude-2924-c7b
rm -rf "$out"; mkdir -p "$out"
B=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
(cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${B[@]}" \
    --list -c --tier1 --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    --list -c --tier1 --lanes 1 "$lua"/*.c \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> logs/status.txt
rm -rf "$out"
date -u +%FT%TZ > logs/.done
