#!/bin/bash
# #2972, Tier 0's vector compile paying for a function's entries: head (branch c2972 from c2972.bundle) against its base
# BASE (#2975's head e91cd2582) on the 9700X, Release, every run under the lock, timings on CPU 2.
# 1. test-tier0 (with --cross-check) and test-tier0-inline (both shapes) by head;
# 2. benchmark-backend-source --only vector on tiny.c and on Lua's units, three rounds each, every run from a fresh copy
#    of its executable;
# 3. -c, -c -g and -c --verify objects of sqlite3.c, Lua, musl, buster's main.c and tiny.c by base and head, every
#    compile in one directory, byte by byte;
# 4. whole compiles, ab around time-runs: -c of sqlite3.c, Lua's units, buster's main.c and tiny.c.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Tier 0 vector compile: a function of a few entries" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2972
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
BASE=${BASE:-e91cd2582}
mkdir -p compilers logs copies
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q --shared $D/../c7gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side fetch -q "$D/c2972.bundle" "+refs/heads/c2972:refs/heads/c2972" || { echo "bundle failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach "$BASE" && git -C src-base reset -q --hard
git -C src-head checkout -q --detach refs/heads/c2972 && git -C src-head reset -q --hard
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
for t in "test-tier0 --cross-check" "test-tier0-inline" "test-tier0-inline --tier0-inline-shapes"; do
    n=$(echo "$t" | tr ' ' _)
    (cd src-head && $L timeout -k 5 1500 ../compilers/head $t > "$D/logs/$n.log" 2>&1; echo "$t: $?" >> "$D/logs/status.txt")
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
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
        run_copy $side logs/backend-tiny-$side-$round.log benchmark-backend-source --only vector "$D/tiny.c"
        echo "backend tiny $side $round: $?" >> logs/status.txt
        run_copy $side logs/backend-lua-$side-$round.log benchmark-backend-source --only vector "$lua"/*.c
        echo "backend lua $side $round: $?" >> logs/status.txt
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
B=(-march=znver5 -I"$D/src-base/src" -fwrapv -funsigned-char -fno-strict-aliasing "$D/src-base/src/buster/compiler/main.c")
objects=/dev/shm/claude-2972-objects
for mode in plain g verify; do
    rm -rf "$objects"
    if [ $mode = plain ]; then opt=(); elif [ $mode = g ]; then opt=(-g); else opt=(--verify); fi
    for side in base head; do
        cur=$objects/cur
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster" "$cur/tiny"
        (cd "$cur/sqlite" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side sqlite: $?" >> logs/status.txt
        (cd "$cur/lua" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "$lua"/*.c > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side lua: $?" >> logs/status.txt
        (cd "$cur/musl" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side musl: $?" >> logs/status.txt
        (cd "$cur/buster" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${B[@]}" -o main.o > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side buster: $?" >> logs/status.txt
        (cd "$cur/tiny" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "$D/tiny.c" -o tiny.o > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side tiny: $?" >> logs/status.txt
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
out=/dev/shm/claude-2972
rm -rf "$out"; mkdir -p "$out"
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
(cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" \
    --list -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    --list -c --lanes 1 "$lua"/*.c \
    --list -c --lanes 1 "${B[@]}" -o "$out/main.o" \
    --list -c --lanes 1 "$D/tiny.c" -o "$out/tiny.o" \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> logs/status.txt
rm -rf "$out"
date -u +%FT%TZ > logs/.done
