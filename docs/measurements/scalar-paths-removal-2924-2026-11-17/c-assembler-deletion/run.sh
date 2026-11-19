#!/bin/bash
# #2924 C11a, the assembler's lexer, register cache, batch parser and matcher twins deleted: head (22f3d4625, branch c11
# from c11.bundle) against its base 5da09045f (the tests commit, the twins present) on the 9700X, Release, every run
# under the lock, timings on CPU 2.
# 1. -c (Tier 0) and --tier1 objects of sqlite3.c, Lua, musl (inline assembly) and buster's main.c by base and head,
#    byte by byte; `assemble` objects of the gate's three real inputs too;
# 2. benchmark-assembler --only vector by base, head and base again, three rounds: the three real inputs and two
#    synthetic workloads;
# 3. whole compiles, ab around time-runs: -c of musl's units and of sqlite3.c;
# 4. on head: the assembler's, the matcher's and inline assembly's tests, the complete driver's checks, the call graph's
#    and the unity ownership check.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the assembler, C11a" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
G=$D/../c11gate/inputs
BASE=${BASE:-5da09045f}
HEAD_COMMIT=${HEAD_COMMIT:-22f3d4625}
mkdir -p compilers logs copies
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q --shared $D/../c7gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side fetch -q "$D/c11.bundle" "+refs/heads/c11:refs/heads/c11" || { echo "bundle failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach "$BASE" && git -C src-base reset -q --hard
git -C src-head checkout -q --detach "$HEAD_COMMIT" && git -C src-head reset -q --hard
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
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
objects=/dev/shm/claude-2924-c11-objects
for mode in tier0 tier1; do
    rm -rf "$objects"
    if [ $mode = tier1 ]; then opt=(--tier1); else opt=(); fi
    for side in base head; do
        cur=$objects/cur
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster" "$cur/assemble"
        (cd "$cur/sqlite" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side sqlite: $?" >> logs/status.txt
        (cd "$cur/lua" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "$lua"/*.c > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side lua: $?" >> logs/status.txt
        (cd "$cur/musl" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side musl: $?" >> logs/status.txt
        (cd "$cur/buster" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${B[@]}" -o main.o > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side buster: $?" >> logs/status.txt
        if [ $mode = tier0 ]; then
            for input in sqlite3-gcc sqlite3-clang-intel lvm-clang; do
                if [ $input = sqlite3-clang-intel ]; then syntax=(--intel); else syntax=(); fi
                $L timeout -k 5 900 "$D/compilers/$side" assemble "${syntax[@]}" -o "$cur/assemble/$input.o" "$G/$input.s" > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"; echo "assemble $side $input: $?" >> logs/status.txt
            done
        fi
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
for round in 1 2 3; do
    for side in base head base; do
        for input in sqlite3-gcc sqlite3-clang-intel lvm-clang; do
            run_copy $side "logs/assembler-$round-$side-$input.log" benchmark-assembler --only vector --input "$G/$input.s"; echo "benchmark-assembler $round $side $input: $?" >> logs/status.txt
        done
        for workload in mixed att; do
            run_copy $side "logs/assembler-$round-$side-$workload.log" benchmark-assembler --only vector --workload $workload --functions 256; echo "benchmark-assembler $round $side $workload: $?" >> logs/status.txt
        done
    done
done
out=/dev/shm/claude-2924-c11
rm -rf "$out"; mkdir -p "$out"
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
(cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" \
    --list -c --lanes 1 "${M[@]}" "${files[@]}" \
    --list -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> logs/status.txt
rm -rf "$out"
cd "$D/src-head"
mapfile -d '' -t flags < <(env -u BUSTER_SANITIZER BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release)
export FLAGS="${flags[*]}"
i=0
while IFS= read -r t; do
    [ -z "$t" ] && continue
    i=$((i+1))
    $L timeout -k 5 3000 bash -c "./build/compiler $t" > "$D/logs/t$i.log" 2>&1
    echo "$t: $?" >> "$D/logs/status.txt"
done <<'LIST'
test-assembler --cross-check
test-assembler --seed 7
test-x86-semantics --cross-check
test-x86-target
test-x86-target-selection
test-checker-asm
test-call-graph
-fsyntax-only -Wall -Werror $FLAGS -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
--lanes 1 --verify -c $FLAGS -o /dev/shm/claude-2924-c11-final.o -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
test-files $FLAGS -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c src/buster/compiler/*_benchmark.c
LIST
rm -f /dev/shm/claude-2924-c11-final.o
$L timeout -k 5 1800 ./build.sh check-call-graph --config Release > "$D/logs/check-call-graph.log" 2>&1; echo "check-call-graph: $?" >> "$D/logs/status.txt"
cc -std=c17 -O2 -o "$D/br" tools/ci/build_regression.c && $L timeout -k 5 1800 "$D/br" --ownership-only "$PWD/build/cmake/native/Release/compiler" > "$D/logs/ownership.log" 2>&1; echo "ownership: $?" >> "$D/logs/status.txt"
echo done >> "$D/logs/status.txt"
date -u +%FT%TZ > "$D/logs/.done"
