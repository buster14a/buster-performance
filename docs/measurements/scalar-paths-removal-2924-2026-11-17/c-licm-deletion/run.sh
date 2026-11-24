#!/bin/bash
# #2979 (#2924's C9, LICM): LICM's twin and whole-function oracle deleted. Head (the deletion) against base (the tests
# commit, both paths present) on the 9700X, Release, every run under the lock, timings on CPU 2.
# 1. Objects of sqlite3.c, Lua 5.4.8, musl's units and buster's main.c by base and head, byte by byte, in four modes:
#    --tier1 (the vector-only LICM by default), --tier1 --tier1-passes=+licm (the unrestricted walk), --tier1
#    --tier1-passes=+hoist (the pressure policy) and --scalar --tier1 --tier1-passes=+licm (the flag LICM no longer reads);
# 2. whole compiles, ab around time-runs: -c --tier1 of sqlite3.c and Lua's units, and -c --tier1 --tier1-passes=+licm
#    of sqlite3.c;
# 3. on head: the IR, SSA and Tier 1 tests, the source tests on c-testsuite's subset, the complete driver's checks, the
#    call graph's and the unity ownership check.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2979 EXCLUSIVE_TITLE="LICM's twin and whole-function oracle deleted (#2979, #2924)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2979
L=~/buster-fast-bench/exclusive.sh
G=~/buster-fast-bench/2924-c-df-claude
BASE=${BASE:?}
HEAD_COMMIT=${HEAD_COMMIT:?}
BRANCH=${BRANCH:-claude/confident-gates-c3qaej}
mkdir -p compilers logs copies
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q --shared $G/c7gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main "$BRANCH" || { echo "fetch failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach "$BASE" && git -C src-base reset -q --hard
git -C src-head checkout -q --detach "$HEAD_COMMIT" && git -C src-head reset -q --hard
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$G/c3pr/inputs/lua-5.4.8/src
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
objects=/dev/shm/claude-2979-objects
for mode in tier1 licm hoist scalar-licm; do
    rm -rf "$objects"
    case $mode in
        tier1) opt=(--tier1) ;;
        licm) opt=(--tier1 --tier1-passes=+licm) ;;
        hoist) opt=(--tier1 --tier1-passes=+hoist) ;;
        scalar-licm) opt=(--scalar --tier1 --tier1-passes=+licm) ;;
    esac
    for side in base head; do
        cur=$objects/cur
        mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl" "$cur/buster"
        (cd "$cur/sqlite" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side sqlite: $?" >> logs/status.txt
        (cd "$cur/lua" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "$lua"/*.c > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side lua: $?" >> logs/status.txt
        (cd "$cur/musl" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side musl: $?" >> logs/status.txt
        (cd "$cur/buster" && $L timeout -k 5 1500 "$D/compilers/$side" -c "${opt[@]}" --lanes 1 "${B[@]}" -o main.o > /dev/null 2>> "$D/logs/stderr-$mode-$side.txt"); echo "objects $mode $side buster: $?" >> logs/status.txt
        mv "$cur" "$objects/$side"
    done
    n=0; d=0
    while read -r f; do
        n=$((n+1))
        cmp -s "$objects/base/$f" "$objects/head/$f" || { d=$((d+1)); echo "differs $mode: $f" >> logs/objects-compare.txt; }
    done < <(cd "$objects/base" && find . -name '*.o' | sort)
    echo "objects $mode: $n compared, $d differ" >> logs/status.txt
    cmp -s "$D/logs/stderr-$mode-base.txt" "$D/logs/stderr-$mode-head.txt"; echo "stderr $mode same: $?" >> logs/status.txt
done
rm -rf "$objects"
out=/dev/shm/claude-2979-time
rm -rf "$out"; mkdir -p "$out"
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
(cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
    -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" \
    --list -c --tier1 --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    --list -c --tier1 --lanes 1 "$lua"/*.c \
    --list -c --tier1 --tier1-passes=+licm --lanes 1 "${S[@]}" -o "$out/sqlite3-licm.o" \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> logs/status.txt
rm -rf "$out"
cd "$D/src-head"
if [ ! -d build/c-testsuite/tests ]; then
    rm -rf build/c-testsuite
    git init -q --template= build/c-testsuite
    git -C build/c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
    git -C build/c-testsuite checkout -q FETCH_HEAD
fi
export CT="$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt | tr '\n' ' ')"
mapfile -d '' -t flags < <(env -u BUSTER_SANITIZER BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release)
export FLAGS="${flags[*]}"
i=0
while IFS= read -r t; do
    [ -z "$t" ] && continue
    i=$((i+1))
    $L timeout -k 5 3000 bash -c "./build/compiler $t" > "$D/logs/t$i.log" 2>&1
    echo "$t: $?" >> "$D/logs/status.txt"
done <<'LIST'
test-ir
test-ir-simd
test-ir-parse
test-ir-metamorphic --seed 731 --count 6
test-ir-metamorphic
test-ssa-ir
test-ir-optimize
test-ir-gvn
test-ir-licm
test-ir-sroa
test-ir-unroll
test-ir-inline
test-ir-vectorize
test-tier1-pipeline --cross-check
test-tier1-masks
test-call-graph
test-ir-source $CT
test-ir-source --passes $CT
test-ssa-source --typed --tier1 $CT
test-ir-source --simd -march=x86-64-v4 tests/ir/vector-i32.c tests/ir/mask-builtins.c tests/ir/bmi-builtins.c tests/ir/vector-rows.c tests/ir/carrier-rows.c
-fsyntax-only -Wall -Werror $FLAGS -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
--lanes 1 --verify -c $FLAGS -o /dev/shm/claude-2979-final.o -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
LIST
rm -f /dev/shm/claude-2979-final.o
$L timeout -k 5 1800 ./build.sh check-call-graph --config Release > "$D/logs/check-call-graph.log" 2>&1; echo "check-call-graph: $?" >> "$D/logs/status.txt"
cc -std=c17 -O2 -o "$D/br" tools/ci/build_regression.c && $L timeout -k 5 1800 "$D/br" --ownership-only "$PWD/build/cmake/znver5/Release/compiler" > "$D/logs/ownership.log" 2>&1; echo "ownership: $?" >> "$D/logs/status.txt"
echo done >> "$D/logs/status.txt"
date -u +%FT%TZ > "$D/logs/.done"
