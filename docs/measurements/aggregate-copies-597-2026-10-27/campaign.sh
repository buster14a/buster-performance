#!/usr/bin/env bash
# Each complete compile sweep, runtime sweep, build and test takes its own shared-host lock.
set -euo pipefail
cd "$(dirname "$0")"
root=$(pwd)
export EXCLUSIVE_OWNER=codex-597
export EXCLUSIVE_TITLE='Buster #597 aggregate-copy qualification'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/597
lock="$HOME/buster-fast-bench/exclusive.sh"
mkdir -p logs tmp inputs objects runs
case ${1:-compile} in
prepare)
    "$lock" bash -c 'clang -std=c17 -O2 -Wall -Wextra -Werror generate.c -o generate && clang -std=c17 -O2 -Wall -Wextra -Werror compare.c -o compare'
    { lscpu; clang --version; uname -a; sha256sum ../base/build/compiler ../head/build/compiler *.c campaign.sh; } > logs/identity.txt
    for size in 16 32 64 128 255 256 257 512 1024 4096 8192 16384 65536 262144; do
        for mode in copy kept same all forced; do ./generate "$size" "$mode" > "inputs/$size-$mode.c"; done
    done
    sha256sum inputs/*.c > logs/inputs.sha256
    ;;
tests)
    compiler=$(realpath ../head/build/compiler)
    cat > tests.list <<LIST
== Checker including aggregate-copy regressions
$compiler test-checker --seed 133
== Native driver and runtime binding [8 CPUs]
$compiler test-checker-driver --executable $compiler
== Function lanes and runtime-symbol determinism [8 CPUs]
$compiler test-check-lanes
== Tier 0 ABI consumers
$compiler test-tier0 --cross-check
== Native and object-output aggregate assignment
./direct.sh $compiler
LIST
    "$lock" "$compiler" parallel --jobs 8 --timeout 110 tests.list > logs/tests.log 2>&1
    ;;
qualify)
    "$lock" taskset -c 2 ./compare 0 full > logs/compile-0.csv 2> logs/compile-0.err
    size -A objects/*.o > logs/object-sections.txt
    objdump -dr objects/head-262144-copy.o > logs/head-copy-disassembly.txt
    objdump -dr objects/base-8192-copy.o > logs/base-copy-disassembly.txt
    readelf -rs objects/head-262144-copy.o > logs/head-copy-symbols.txt
    for size in 16 32 64 128 255 256; do
        for mode in copy kept same; do
            if cmp "objects/base-$size-$mode.o" "objects/head-$size-$mode.o"; then
                printf 'identical size=%s mode=%s\n' "$size" "$mode"
            else
                printf 'different size=%s mode=%s\n' "$size" "$mode"
            fi
        done
    done > logs/small-object-identity.txt
    ;;
compile)
    for round in 0 1 2; do
        [ ! -f STOP ] || exit 0
        "$lock" taskset -c 2 ./compare "$round" > "logs/compile-$round.csv" 2> "logs/compile-$round.err"
    done
    ;;
build-runtime)
    "$lock" ./build-runtime.sh > logs/build-runtime.log 2>&1
    ;;
runtime)
    for round in 0 1 2; do
        "$lock" taskset -c 2 ./compare "$round" runtime > "logs/runtime-$round.txt" 2> "logs/runtime-$round.err"
    done
    ;;
control)
    sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
    sha256sum "$sqlite/sqlite3.c" > logs/sqlite-input.sha256
    "$lock" taskset -c 2 ../head/build/compiler measure-compile --runs 33 --warmups 2 --reference ../base/build/compiler --directory "$root/tmp" -- --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > logs/sqlite.times 2>&1
    ;;
esac
