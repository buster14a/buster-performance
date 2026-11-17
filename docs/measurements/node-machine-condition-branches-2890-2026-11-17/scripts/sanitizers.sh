#!/bin/bash
# sanitizers.sh TREE OUT "SHADOW MODES": the sanitizer rows a pull request's checks don't run, in the worktree TREE (at the
# commit under test): memory, address and thread on the x86-64 host (the scalar paths) and on the native one. Each row: a
# Release build as CI's rows build it, the part of test-checker with the node machine's tests (part 5 of 8), and for
# memory and address the shadow in each of SHADOW MODES (a mode a word group, separated by ';') on sqlite3.c, Lua and
# the compiler's own source. Progress is OUT/progress.txt; a report is a file under OUT/reports-ROW.
set -u
tree=$1; out=$2; modes=$3
cd "$tree" || exit 1
mkdir -p "$out"
. /home/user/keep/corpora.sh
symbolizer=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > "$out/predefines.h"
main_arguments="-march=native -Isrc -fwrapv -funsigned-char --predefines $out/predefines.h src/buster/compiler/main.c"
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
    start=$(date +%s)
    "$out/compiler-$name" test-checker --seed 133 --part 5/8 > "$out/part5-$name.out" 2> "$out/part5-$name.err"
    echo "$name part5 status $? wall $(( $(date +%s) - start )) s; $(tail -1 "$out/part5-$name.out"); reports $(ls "$reports" | wc -l)" >> "$out/progress.txt"
    if [ "$san" = memory ] || [ "$san" = address ]; then
        IFS=';' read -r -a list <<< "$modes"
        n=0
        for mode in "${list[@]}"; do
            n=$((n + 1))
            for unit in sqlite lua main; do
                case $unit in main) a=$main_arguments ;; sqlite) a=$sqlite_arguments ;; lua) a=$lua_arguments ;; esac
                (
                    start=$(date +%s)
                    bash -c "$out/compiler-$name measure-node-machine --shadow $mode $a" > "$out/shadow-$name-$unit-$n.out" 2> "$out/shadow-$name-$unit-$n.err"
                    echo "$name shadow $unit [$mode] status $? wall $(( $(date +%s) - start )) s; reports $(ls "$reports" | wc -l)" >> "$out/progress.txt"
                ) &
            done
            wait
        done
    fi
    rm -f "$out/compiler-$name"
done
echo "all done" >> "$out/progress.txt"
