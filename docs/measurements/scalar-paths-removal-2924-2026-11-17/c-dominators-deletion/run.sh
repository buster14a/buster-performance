#!/bin/bash
# #2924 C4, dominators' deletion: head c6eb0abe7 against its base 295417ae7 (main after #2951) on the 9700X, Release,
# every run under the lock, timings on CPU 2. test-dominators; test-ir-source --dominators-cfg on sqlite3.c, which also
# checks every real CFG against the whole definition; benchmark-dominators --cfg on that export, base's scalar and
# AUTO paths against head, tree and all outputs, three rounds; the synthetic shapes, base's scalar path against head,
# three rounds; -c objects of sqlite3.c, Lua and musl by base and head, default and --scalar, compared byte by byte;
# whole-compile timings with ab around time-runs; the disassembly by function; the sections.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: dominators' deletion" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p compilers logs
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q $P/src-main src-$side || exit 1; fi
    git -C src-$side fetch -q "$D/c4del.bundle" "+refs/heads/c4-base:refs/heads/c4-base" "+refs/heads/c4-dominators:refs/heads/c4-dominators" || { echo "bundle failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach c4-base
git -C src-head checkout -q --detach c4-dominators
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
(cd src-head && $L timeout -k 5 900 ../compilers/head test-dominators > "$D/logs/test-dominators.log" 2>&1; echo "test-dominators: $?" >> "$D/logs/status.txt")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
rm -f "$D/sqlite.cfg"
(cd src-head && $L timeout -k 5 1500 ../compilers/head test-ir-source --dominators-cfg "$D/sqlite.cfg" --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$sqlite/sqlite3.c" > "$D/logs/export.log" 2>&1)
echo "export: $?" >> logs/status.txt
for round in 1 2 3; do
    for outputs in tree all; do
        for side in base-scalar base-auto head; do
            case $side in
                base-scalar) cmd=(./compilers/base benchmark-dominators --cfg "$D/sqlite.cfg" --outputs $outputs --only scalar) ;;
                base-auto) cmd=(./compilers/base benchmark-dominators --cfg "$D/sqlite.cfg" --outputs $outputs --only auto) ;;
                head) cmd=(./compilers/head benchmark-dominators --cfg "$D/sqlite.cfg" --outputs $outputs) ;;
            esac
            $L timeout -k 5 900 taskset -c 2 "${cmd[@]}" > logs/cfg-$outputs-$side-$round.log 2>&1
            echo "cfg $outputs $side $round: $?" >> logs/status.txt
        done
    done
    $L timeout -k 5 900 taskset -c 2 ./compilers/base benchmark-dominators --only scalar > logs/synthetic-base-scalar-$round.log 2>&1
    echo "synthetic base-scalar $round: $?" >> logs/status.txt
    $L timeout -k 5 900 taskset -c 2 ./compilers/head benchmark-dominators > logs/synthetic-head-$round.log 2>&1
    echo "synthetic head $round: $?" >> logs/status.txt
done
rm -f "$D/sqlite.cfg"
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
objects=/dev/shm/claude-2924-c4del-objects
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
out=/dev/shm/claude-2924-c4del
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
    objdump -d --no-show-raw-insn compilers/$side > /dev/shm/claude-2924-c4del-$side.s && python3 disassembly/split.py /dev/shm/claude-2924-c4del-$side.s /dev/shm/claude-2924-c4del-$side.json
    rm -f /dev/shm/claude-2924-c4del-$side.s
done
python3 disassembly/compare.py /dev/shm/claude-2924-c4del-base.json /dev/shm/claude-2924-c4del-head.json > logs/compare.txt
rm -f /dev/shm/claude-2924-c4del-*.json
for side in base head; do
    readelf -sW compilers/$side | awk '$4 == "FUNC"' > logs/$side-functions.txt
    readelf -SW compilers/$side > logs/$side-sections.txt
done
date -u +%FT%TZ > logs/.done
