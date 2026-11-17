#!/bin/bash
# sanitizers-arenas.sh TREE OUT: the sanitizer rows a pull request's checks don't run, for buster#2873's second piece (the
# arenas' calls), in the worktree TREE: memory, address and thread on the x86-64 host and on the native one. Each row: a
# Release build as CI's rows build it, the tests of what the change touches (the lanes' and the arenas', the lanes of
# the checker, the units', the deferred checker's, the profile's), -c of sqlite3.c and of the compiler's own source's
# -fsyntax-only. Progress is OUT/progress.txt; a report is a file under OUT/reports-ROW.
set -u
tree=$1; out=$2
cd "$tree" || exit 1
mkdir -p "$out"
. /home/user/keep/corpora.sh
symbolizer=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > "$out/predefines.h"
for row in x86-64:memory x86-64:address x86-64:thread native:memory native:address native:thread; do
    host=${row%%:*}; san=${row#*:}; name=$host-$san
    start=$(date +%s)
    BUSTER_HOST_ARCH=$host BUSTER_SANITIZER=$san BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_LINKER=lld BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$out/build-$name.log" 2>&1
    echo "$name build status $? wall $(( $(date +%s) - start )) s" >> "$out/progress.txt"
    cp build/compiler "$out/compiler-$name"
    reports=$out/reports-$name
    mkdir -p "$reports"
    export MSAN_SYMBOLIZER_PATH=$symbolizer ASAN_SYMBOLIZER_PATH=$symbolizer
    export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
    export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
    export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
    export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
    export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$symbolizer:log_path=$reports/report"
    n=0
    for command in "test-lanes" "test-check-lanes" "test-check-units" "test-checker-deferred" "test-profile" "test-checker --seed 133 --part 5/8"; do
        n=$((n + 1))
        start=$(date +%s)
        "$out/compiler-$name" $command > "$out/test-$name-$n.out" 2> "$out/test-$name-$n.err"
        echo "$name [$command] status $? wall $(( $(date +%s) - start )) s; $(tail -1 "$out/test-$name-$n.out" | cut -c1-80); reports $(ls "$reports" | wc -l)" >> "$out/progress.txt"
    done
    start=$(date +%s)
    bash -c "$out/compiler-$name -c $sqlite_arguments -o $out/sqlite-$name.o" > "$out/compile-$name-sqlite.out" 2> "$out/compile-$name-sqlite.err"
    echo "$name [-c sqlite3.c] status $? wall $(( $(date +%s) - start )) s; reports $(ls "$reports" | wc -l)" >> "$out/progress.txt"
    start=$(date +%s)
    "$out/compiler-$name" -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > "$out/compile-$name-main.out" 2> "$out/compile-$name-main.err"
    echo "$name [-fsyntax-only main.c] status $? wall $(( $(date +%s) - start )) s; reports $(ls "$reports" | wc -l)" >> "$out/progress.txt"
    rm -f "$out/compiler-$name" "$out/sqlite-$name.o"
done
echo "all done" >> "$out/progress.txt"
