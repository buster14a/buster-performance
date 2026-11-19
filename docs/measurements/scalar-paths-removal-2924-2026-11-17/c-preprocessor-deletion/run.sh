#!/bin/bash
# #2924 C12a, the preprocessor's twins deleted but pp_define's body scan: head (cdf49131c, branch c12a from c12a.bundle)
# against its base dbeb325a9 (the tests commit, the twins present) on the 9700X, Release, every run under the lock,
# timings on CPU 2.
# 1. -E text of sqlite3.c, Lua's units, musl's units and buster's main.c (-E and -E -P) by base and head, byte by byte;
#    -c (Tier 0) and --tier1 objects of the same, byte by byte;
# 2. benchmark-preprocessor --only vectorized by base, head and base again, three rounds: main.c, sqlite3.c, --tables
#    src, --defines src, --embed 16777216;
# 3. whole compiles, ab around time-runs: -E of sqlite3.c, Lua's units and musl's units; -c of musl's units and sqlite3.c;
# 4. on head: the preprocessor's, the files', the parser's and refinement's tests, the complete driver's checks, the call
#    graph's and the unity ownership check.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the preprocessor, C12a" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
BASE=${BASE:-dbeb325a9}
HEAD_COMMIT=${HEAD_COMMIT:-cdf49131c}
mkdir -p compilers logs copies
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q --shared $D/../c7gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side fetch -q "$D/c12a.bundle" "+refs/heads/c12a:refs/heads/c12a" || { echo "bundle failed" >> logs/status.txt; exit 1; }
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
BC=(-march=znver5 -I"$D/src-base/src" -fwrapv -funsigned-char -DBUSTER_COMPLETE_DRIVER=1 "$D/src-base/src/buster/compiler/main.c")
# 1. -E text and objects.
text=/dev/shm/claude-2924-c12a-text
rm -rf "$text"; mkdir -p "$text"
for side in base head; do
    exe=$D/compilers/$side
    $L timeout -k 5 900 "$exe" -E "${S[@]}" -o "$text/$side-sqlite.i" 2>> "$D/logs/stderr-e-$side.txt"; echo "text $side sqlite: $?" >> logs/status.txt
    $L timeout -k 5 900 bash -c '"$0" -E "$@"' "$exe" "$lua"/*.c > "$text/$side-lua.i" 2>> "$D/logs/stderr-e-$side.txt"; echo "text $side lua: $?" >> logs/status.txt
    $L timeout -k 5 900 bash -c '"$0" -E "$@"' "$exe" "${M[@]}" "${files[@]}" > "$text/$side-musl.i" 2>> "$D/logs/stderr-e-$side.txt"; echo "text $side musl: $?" >> logs/status.txt
    $L timeout -k 5 900 "$exe" -E "${BC[@]}" -o "$text/$side-buster.i" 2>> "$D/logs/stderr-e-$side.txt"; echo "text $side buster: $?" >> logs/status.txt
    $L timeout -k 5 900 "$exe" -E -P "${BC[@]}" -o "$text/$side-buster-p.i" 2>> "$D/logs/stderr-e-$side.txt"; echo "text $side buster -P: $?" >> logs/status.txt
done
for list in sqlite lua musl buster buster-p; do
    cmp -s "$text/base-$list.i" "$text/head-$list.i"; echo "same text $list: $? ($(wc -c < "$text/head-$list.i") bytes)" >> logs/status.txt
done
rm -rf "$text"
objects=/dev/shm/claude-2924-c12a-objects
for mode in tier0 tier1; do
    rm -rf "$objects"
    if [ $mode = tier1 ]; then opt=(--tier1); else opt=(); fi
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
done
rm -rf "$objects"
# 2. The preprocessor's benchmarks, the vectorized kernels alone.
for round in 1 2 3; do
    for pair in base:base head:head base:base-again; do
        side=${pair%%:*}; name=${pair#*:}
        run_copy $side "logs/bench-$round-$name-buster.log" benchmark-preprocessor --only vectorized "${BC[@]}"; echo "bench $round $name buster: $?" >> logs/status.txt
        run_copy $side "logs/bench-$round-$name-sqlite.log" benchmark-preprocessor --only vectorized "${S[@]}"; echo "bench $round $name sqlite: $?" >> logs/status.txt
        run_copy $side "logs/bench-$round-$name-tables.log" benchmark-preprocessor --tables "$D/src-base/src"; echo "bench $round $name tables: $?" >> logs/status.txt
        run_copy $side "logs/bench-$round-$name-defines.log" benchmark-preprocessor --defines --only vectorized "$D/src-base/src"; echo "bench $round $name defines: $?" >> logs/status.txt
        run_copy $side "logs/bench-$round-$name-embed.log" benchmark-preprocessor --embed 16777216; echo "bench $round $name embed: $?" >> logs/status.txt
    done
done
# The start section's functions, base's and head's.
for side in base head; do
    read -r start size < <(readelf -SW compilers/$side | awk '$2==".text.buster_start" {print $4, $6} $3==".text.buster_start" {print $5, $7}' | head -1)
    s=$((16#$start)); e=$((s + 16#$size))
    readelf -sW compilers/$side | awk -v s=$s -v e=$e '$4=="FUNC" { a=strtonum("0x"$2); if (a>=s && a<e) print $8 }' | sort -u > logs/start-$side.txt
done
echo "start: $(wc -l < logs/start-base.txt) base, $(wc -l < logs/start-head.txt) head; only base: $(comm -23 logs/start-base.txt logs/start-head.txt | tr '\n' ' '); only head: $(comm -13 logs/start-base.txt logs/start-head.txt | tr '\n' ' ')" >> logs/status.txt
# 3. Whole compiles.
out=/dev/shm/claude-2924-c12a
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
for list in e-sqlite e-lua e-musl c-musl c-sqlite; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        e-sqlite) args=(-E "${S[@]}" -o "$out/sqlite3.i");;
        e-lua) args=(-E "$lua"/*.c);;
        e-musl) args=(-E "${M[@]}" "${files[@]}");;
        c-musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
        c-sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
    esac
    (cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
        -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
rm -rf "$out"
# 4. Head's tests.
cd "$D/src-head"
mapfile -d '' -t flags < <(env -u BUSTER_SANITIZER BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release)
export FLAGS="${flags[*]}"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
i=0
while IFS= read -r t; do
    [ -z "$t" ] && continue
    i=$((i+1))
    $L timeout -k 5 3000 bash -c "./build/compiler $t" > "$D/logs/t$i.log" 2>&1
    echo "$t: $?" >> "$D/logs/status.txt"
done <<'LIST'
test-preprocessor --jobs 8
test-preprocessor --tables src
test-preprocessor --clang
test-preprocessor-fuzz --std c17
test-preprocessor-fuzz --std c23
test-files
test-files --flat src
test-files $FLAGS -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c src/buster/compiler/*_benchmark.c
test-parser
test-parser --clang -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c
test-refinement src
test-lexer
test-call-graph
parse -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
-fsyntax-only -Wall -Werror $FLAGS -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
--lanes 1 --verify -c $FLAGS -o /dev/shm/claude-2924-c12a-final.o -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
--scalar --lanes 1 --verify --lower-all -c $FLAGS -o /dev/shm/claude-2924-c12a-final.o -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
LIST
rm -f /dev/shm/claude-2924-c12a-final.o
$L timeout -k 5 1800 ./build.sh check-call-graph --config Release > "$D/logs/check-call-graph.log" 2>&1; echo "check-call-graph: $?" >> "$D/logs/status.txt"
cc -std=c17 -O2 -o "$D/br" tools/ci/build_regression.c && $L timeout -k 5 1800 "$D/br" --ownership-only "$PWD/build/cmake/native/Release/compiler" > "$D/logs/ownership.log" 2>&1; echo "ownership: $?" >> "$D/logs/status.txt"
echo done >> "$D/logs/status.txt"
date -u +%FT%TZ > "$D/logs/.done"
