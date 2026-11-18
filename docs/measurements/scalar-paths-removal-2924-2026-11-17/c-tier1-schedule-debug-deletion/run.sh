#!/bin/bash
# #2924 C7's first slice, the schedule's and the debug metadata's twins deleted: head HEAD (the PR's branch on GitHub)
# against its base BASE on the 9700X, Release, every run under the lock, timings on CPU 2.
# 1. test-tier1-schedule and test-check-debug by head;
# 2. benchmark-tier1-schedule, three rounds: base's vector row against head's one row;
# 3. objects by base and head of --tier1 --tier1-schedule=post -c (sqlite3.c, Lua, musl) and --tier1 -g -c (Lua and
#    musl: sqlite3.c's -g refuses on main, #2870), every compile in one directory, compared byte by byte;
# 4. whole compiles, ab around time-runs: --tier1 -g -c of Lua and --tier1 --tier1-schedule=post -c of sqlite3.c.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's schedule and debug metadata" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
BASE=${BASE:?}
HEAD_SHA=${HEAD:?}
mkdir -p compilers logs
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q --shared $D/../c7gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side fetch -q https://github.com/buster14a/buster claude/wonderful-wozniak-vbfba7 || { echo "branch fetch failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach "$BASE" && git -C src-base reset -q --hard
git -C src-head checkout -q --detach "$HEAD_SHA" && git -C src-head reset -q --hard
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
(cd src-head && $L timeout -k 5 900 ../compilers/head test-tier1-schedule > "$D/logs/test-tier1-schedule.log" 2>&1; echo "test-tier1-schedule: $?" >> "$D/logs/status.txt")
(cd src-head && $L timeout -k 5 900 ../compilers/head test-check-debug --cross-check > "$D/logs/test-check-debug.log" 2>&1; echo "test-check-debug --cross-check: $?" >> "$D/logs/status.txt")
for round in 1 2 3; do
    for side in base head; do
        $L timeout -k 5 900 taskset -c 2 ./compilers/$side benchmark-tier1-schedule > logs/bench-$side-$round.log 2>&1
        echo "bench $side $round: $?" >> logs/status.txt
    done
done
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
objects=/dev/shm/claude-2924-c7a-objects
rm -rf "$objects"
for side in base head; do
    for mode in post g; do
        cur=$objects/cur
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl"
        if [ $mode = post ]; then
            opt=(--tier1 --tier1-schedule=post)
            (cd "$cur/sqlite" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr-$side-$mode.txt"); echo "objects $side $mode sqlite: $?" >> logs/status.txt
        else
            opt=(--tier1 -g)
        fi
        (cd "$cur/lua" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "$lua"/*.c > /dev/null 2>> "$D/logs/stderr-$side-$mode.txt"); echo "objects $side $mode lua: $?" >> logs/status.txt
        (cd "$cur/musl" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr-$side-$mode.txt"); echo "objects $side $mode musl: $?" >> logs/status.txt
        mv "$cur" "$objects/$side-$mode"
    done
done
for mode in post g; do
    n=0; d=0
    while read -r f; do
        n=$((n+1))
        cmp -s "$objects/base-$mode/$f" "$objects/head-$mode/$f" || { d=$((d+1)); echo "differs: $f" >> logs/objects-compare-$mode.txt; }
    done < <(cd "$objects/base-$mode" && find . -name '*.o' | sort)
    echo "objects $mode: $n compared, $d differ" >> logs/status.txt
done
rm -rf "$objects"
out=/dev/shm/claude-2924-c7a
rm -rf "$out"; mkdir -p "$out"
B=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
(cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${B[@]}" \
    --list -c --tier1 -g --lanes 1 "$lua"/*.c \
    --list -c --tier1 --tier1-schedule=post --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> logs/status.txt
rm -rf "$out"
date -u +%FT%TZ > logs/.done
