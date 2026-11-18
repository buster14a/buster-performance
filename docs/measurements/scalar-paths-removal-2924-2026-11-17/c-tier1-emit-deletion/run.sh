#!/bin/bash
# #2924 C7b-2, Tier 1's emit areas' twins deleted (liveness, allocation, CFG, rematerialization marks, saves, requests):
# head (branch c7b2 from c7b2.bundle) against its base BASE (#2965's head, fetched from GitHub's branch) on the 9700X,
# Release, every run under the lock, timings on CPU 2.
# 1. test-tier1-allocation, -cfg, -emit, -liveness and -pipeline --cross-check by head;
# 2. benchmark-tier1-cfg-source --only cfg and --only intervals on the frozen sqlite3.c, three rounds each, and
#    benchmark-tier1-allocation and
#    benchmark-tier1-select, three rounds each, every run from a fresh copy of its executable;
# 3. --tier1 -c and --tier1 -g -c objects of sqlite3.c, Lua and musl by base and head, every compile in one directory,
#    byte by byte;
# 4. whole compiles, ab around time-runs: --tier1 -c of sqlite3.c and of Lua's units.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's emit areas" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
BASE=${BASE:?}
mkdir -p compilers logs copies
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q --shared $D/../c7gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side fetch -q "$D/c7b2.bundle" "+refs/heads/c7b2:refs/heads/c7b2" || { echo "bundle failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach "$BASE" && git -C src-base reset -q --hard
git -C src-head checkout -q --detach c7b2 && git -C src-head reset -q --hard
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
for t in test-tier1-allocation test-tier1-cfg test-tier1-emit test-tier1-liveness; do
    (cd src-head && $L timeout -k 5 1500 ../compilers/head $t > "$D/logs/$t.log" 2>&1; echo "$t: $?" >> "$D/logs/status.txt")
done
(cd src-head && $L timeout -k 5 1500 ../compilers/head test-tier1-pipeline --cross-check > "$D/logs/test-tier1-pipeline.log" 2>&1; echo "test-tier1-pipeline --cross-check: $?" >> "$D/logs/status.txt")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
H=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
# Every benchmark process runs from a fresh copy: a file's page-cache state can change its rate (c-tier1-select-deletion).
run_copy() {
    local side=$1 log=$2
    shift 2
    cp compilers/$side copies/$side-run
    $L timeout -k 5 900 taskset -c 2 ./copies/$side-run "$@" > "$log" 2>&1
    local status=$?
    rm -f copies/$side-run
    return $status
}
for round in 1 2 3; do
    for side in base head; do
        # Each variant alone: variants timed in turn within a pass change each other's figures.
        for variant in cfg intervals; do
            run_copy $side logs/cfg-source-$variant-$side-$round.log benchmark-tier1-cfg-source --only $variant "${H[@]}" "$sqlite/sqlite3.c"
            echo "cfg-source $variant $side $round: $?" >> logs/status.txt
        done
        run_copy $side logs/allocation-$side-$round.log benchmark-tier1-allocation
        echo "allocation $side $round: $?" >> logs/status.txt
        run_copy $side logs/select-$side-$round.log benchmark-tier1-select --only vector
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
objects=/dev/shm/claude-2924-c7b2-objects
for mode in t1 g; do
    rm -rf "$objects"
    if [ $mode = t1 ]; then opt=(--tier1); else opt=(--tier1 -g); fi
    for side in base head; do
        cur=$objects/cur
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl"
        (cd "$cur/sqlite" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side sqlite: $?" >> logs/status.txt
        (cd "$cur/lua" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "$lua"/*.c > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side lua: $?" >> logs/status.txt
        (cd "$cur/musl" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side musl: $?" >> logs/status.txt
        mv "$cur" "$objects/$side"
    done
    n=0; d=0
    while read -r f; do
        n=$((n+1))
        cmp -s "$objects/base/$f" "$objects/head/$f" || { d=$((d+1)); echo "differs $mode: $f" >> logs/objects-compare.txt; }
    done < <(cd "$objects/base" && find . -name '*.o' | sort)
    echo "objects $mode: $n compared, $d differ" >> logs/status.txt
done
rm -rf "$objects"
out=/dev/shm/claude-2924-c7b2
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
