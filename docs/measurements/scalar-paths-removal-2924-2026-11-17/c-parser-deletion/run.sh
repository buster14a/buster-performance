#!/bin/bash
# #2924 C12b, the parser's twins deleted: head (3c7e1f62b, branch c12b from c12b.bundle) against its base 47470d099
# (the tests commit, the twins present) on the 9700X, Release, every run under the lock, timings on CPU 2.
# 1. -c (Tier 0) and --tier1 objects of sqlite3.c, Lua's units, musl's units and buster's main.c by base and head, byte
#    by byte, and `parse -fsyntax-only`'s output of sqlite3.c and main.c;
# 2. benchmark-parser's input, handoff and vector rows on main.c and sqlite3.c, and benchmark-gnu, by base, head and base
#    again, three rounds;
# 3. whole compiles, ab around time-runs: parse -fsyntax-only of sqlite3.c and main.c, -fsyntax-only of Lua's units and
#    musl's units, -c of sqlite3.c and musl's units;
# 4. the start section's functions, base's and head's;
# 5. on head: the parser's, the GNU records', the files' and the lexer's tests, the complete driver's checks, the call
#    graph's and the unity ownership check.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the parser, C12b" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
BASE=${BASE:-47470d099}
HEAD_COMMIT=${HEAD_COMMIT:-3c7e1f62b}
mkdir -p compilers logs copies
for side in base head; do
    if [ ! -d src-$side ]; then git clone -q --shared $D/../c7gate/src src-$side || exit 1; fi
    git -C src-$side fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
    git -C src-$side fetch -q "$D/c12b.bundle" "+refs/heads/c12b:refs/heads/c12b" || { echo "bundle failed" >> logs/status.txt; exit 1; }
done
git -C src-base checkout -q --detach "$BASE" && git -C src-base reset -q --hard
git -C src-head checkout -q --detach "$HEAD_COMMIT" && git -C src-head reset -q --hard
printf 'base %s\nhead %s\n' "$(git -C src-base rev-parse HEAD)" "$(git -C src-head rev-parse HEAD)" > logs/commits.txt
for side in base head; do
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> logs/status.txt; exit 1; }
    cp src-$side/build/compiler compilers/$side
done
sha256sum compilers/* > logs/compilers.sha256
clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$D/predefines.h"
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
BP=(-march=znver5 -I"$D/src-base/src" -fwrapv -funsigned-char --predefines "$D/predefines.h" -DBUSTER_COMPLETE_DRIVER=1 "$D/src-base/src/buster/compiler/main.c")
# 1. Objects, and the parse's diagnostics.
objects=/dev/shm/claude-2924-c12b-objects
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
for side in base head; do
    $L timeout -k 5 900 "$D/compilers/$side" parse -fsyntax-only "${S[@]}" > "logs/parse-sqlite-$side.txt" 2>&1; echo "parse $side sqlite: $?" >> logs/status.txt
    $L timeout -k 5 900 "$D/compilers/$side" parse -fsyntax-only "${BP[@]}" > "logs/parse-buster-$side.txt" 2>&1; echo "parse $side buster: $?" >> logs/status.txt
done
for list in sqlite buster; do
    cmp -s "logs/parse-$list-base.txt" "logs/parse-$list-head.txt"; echo "same parse output $list: $?" >> logs/status.txt
done
# 2. The parser's and the GNU records' benchmarks.
for round in 1 2 3; do
    for pair in base:base head:head base:base-again; do
        side=${pair%%:*}; name=${pair#*:}
        for row in input handoff vector; do
            run_copy $side "logs/bench-$round-$name-buster-$row.log" benchmark-parser --only $row "${BP[@]}"; echo "bench $round $name buster $row: $?" >> logs/status.txt
            run_copy $side "logs/bench-$round-$name-sqlite-$row.log" benchmark-parser --only $row "${S[@]}"; echo "bench $round $name sqlite $row: $?" >> logs/status.txt
        done
        run_copy $side "logs/gnu-$round-$name-sqlite.log" benchmark-gnu "${S[@]}"; echo "gnu $round $name sqlite: $?" >> logs/status.txt
        run_copy $side "logs/gnu-$round-$name-buster.log" benchmark-gnu "${BP[@]}"; echo "gnu $round $name buster: $?" >> logs/status.txt
    done
done
# 4. The start section's functions, base's and head's.
for side in base head; do
    read -r start size < <(readelf -SW compilers/$side | awk '$2==".text.buster_start" {print $4, $6} $3==".text.buster_start" {print $5, $7}' | head -1)
    s=$((16#$start)); e=$((s + 16#$size))
    readelf -sW compilers/$side | awk -v s=$s -v e=$e '$4=="FUNC" { a=strtonum("0x"$2); if (a>=s && a<e) print $8 }' | sort -u > logs/start-$side.txt
done
echo "start: $(wc -l < logs/start-base.txt) base, $(wc -l < logs/start-head.txt) head; only base: $(comm -23 logs/start-base.txt logs/start-head.txt | tr '\n' ' '); only head: $(comm -13 logs/start-base.txt logs/start-head.txt | tr '\n' ' ')" >> logs/status.txt
# 3. Whole compiles.
out=/dev/shm/claude-2924-c12b
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base")
for list in parse-sqlite parse-buster syntax-lua syntax-musl c-sqlite c-musl; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        parse-sqlite) args=(parse -fsyntax-only "${S[@]}");;
        parse-buster) args=(parse -fsyntax-only "${BP[@]}");;
        syntax-lua) args=(-fsyntax-only "$lua"/*.c);;
        syntax-musl) args=(-fsyntax-only "${M[@]}" "${files[@]}");;
        c-sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        c-musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
    esac
    (cd "$out" && "$D/compilers/base" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/base" \
        -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
rm -rf "$out"
# 5. Head's tests.
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
test-parser
test-parser --clang
test-parser --clang -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c
test-gnu --clang
test-files
test-files --flat src
test-files $FLAGS -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c src/buster/compiler/*_benchmark.c
test-lexer
test-call-graph
parse -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
-fsyntax-only -Wall -Werror $FLAGS -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
--lanes 1 --verify -c $FLAGS -o /dev/shm/claude-2924-c12b-final.o -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
--scalar --lanes 1 --verify --lower-all -c $FLAGS -o /dev/shm/claude-2924-c12b-final.o -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
LIST
rm -f /dev/shm/claude-2924-c12b-final.o
$L timeout -k 5 1800 ./build.sh check-call-graph --config Release > "$D/logs/check-call-graph.log" 2>&1; echo "check-call-graph: $?" >> "$D/logs/status.txt"
cc -std=c17 -O2 -o "$D/br" tools/ci/build_regression.c && $L timeout -k 5 1800 "$D/br" --ownership-only "$PWD/build/cmake/native/Release/compiler" > "$D/logs/ownership.log" 2>&1; echo "ownership: $?" >> "$D/logs/status.txt"
echo done >> "$D/logs/status.txt"
date -u +%FT%TZ > "$D/logs/.done"
