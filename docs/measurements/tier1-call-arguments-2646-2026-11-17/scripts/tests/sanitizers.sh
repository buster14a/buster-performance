#!/usr/bin/env bash
# Each x86-64 sanitizer build of the copy tree (memory, address, thread), then the tests #2646 touches, under CI's options.
set -u
T=$HOME/.cache/claude-2646/mut/tree
O=$HOME/.cache/claude-2646/san
mkdir -p $O
symbolizer=$(ls $HOME/.cache/buster/toolchain/*/llvm-*/bin/llvm-symbolizer | head -1)
corpus=$HOME/.cache/claude-2646/corpus
for s in memory address thread; do
    cd $T && BUSTER_HOST_ARCH=x86-64 BUSTER_SANITIZER=$s BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_LINKER=lld BUSTER_DEBUG_INFO=0 nice ./build.sh --config Release > $O/build-$s.log 2>&1
    echo "$s build exit $?" >> $O/status
    X=$(sed -n 's/^build.sh: Release: \(.*\), published as build\/compiler$/\1/p' $O/build-$s.log | tail -1)
    cp $T/build/compiler $O/compiler-$s
    R=$O/reports-$s; rm -rf $R; mkdir -p $R
    export ASAN_SYMBOLIZER_PATH="$symbolizer" MSAN_SYMBOLIZER_PATH="$symbolizer"
    export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$R/report"
    export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$R/report"
    export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$R/report"
    export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$symbolizer:log_path=$R/report"
    export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$symbolizer:log_path=$R/report"
    C=$O/compiler-$s
    cd /home/user/buster
    run() { name=$1; shift; st=$(date +%s); timeout 3000 "$@" > $O/$s-$name.log 2>&1; echo "$s $name exit=$? $(( $(date +%s) - st ))s reports=$(ls $R | wc -l)" >> $O/status; }
    run tier1-allocation $C test-tier1-allocation
    run tier1-cfg $C test-tier1-cfg
    run tier1-emit $C test-tier1-emit
    run tier1-pipeline $C test-tier1-pipeline
    run ct-self $C test-c-testsuite --self-test
    run ct-size $C test-c-testsuite --tier1 --check-code-size --clang clang --jobs 4 --subset tests/c-testsuite/subset.txt build/c-testsuite
    run sizes $C measure-tier1-programs --sizes-only --check-code-size --clang clang --sqlite $corpus/sqlite --lua $HOME/.cache/claude-2646/lua/src --directory /tmp/claude-0
    run cfg-source-ct $C test-tier1-cfg-source $(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
    run calling-convention $C test-calling-convention --cross-check
    run check-debug $C test-check-debug --cross-check
done
echo done >> $O/status
