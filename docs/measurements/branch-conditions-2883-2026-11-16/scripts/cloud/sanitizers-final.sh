#!/bin/bash
# The final tree's x86-64 memory and address sanitizer builds: test-checker's parts 4 and 5 under each, CI's options.
S=/tmp/claude-0/-home-user-buster/c45a68bf-d025-5d42-ba16-5bb54ca5630c/scratchpad
cd /home/user/buster-san
sym=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer
: > $S/san2-summary.txt
for san in memory address; do
    BUSTER_HOST_ARCH=x86-64 BUSTER_SANITIZER=$san BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_LINKER=lld BUSTER_DEBUG_INFO=0 nice -n 5 ./build.sh --config Release > $S/san2-build-$san.log 2>&1
    echo "$san build status $?" >> $S/san2-summary.txt
    reports=$S/san2-reports-$san; rm -rf $reports; mkdir -p $reports
    export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$reports/report"
    export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$reports/report"
    export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$sym:log_path=$reports/report"
    export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$sym:log_path=$reports/report"
    export BUSTER_CORPUS=/home/user/buster/build/corpus
    for part in 4 5; do
        nice -n 5 ./build/compiler test-checker --seed 133 --part $part/8 > $S/san2-$san-part$part.log 2>&1
        echo "$san part $part status $? $(tail -1 $S/san2-$san-part$part.log)" >> $S/san2-summary.txt
    done
    C=/home/user/buster/build/corpus/sqlite
    nice -n 5 ./build/compiler measure-node-machine --shadow --verify -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C $C/sqlite3.c > $S/san2-$san-shadow.log 2>&1
    echo "$san shadow --verify sqlite3.c status $?" >> $S/san2-summary.txt
    echo "$san reports: $(ls $reports | wc -l)" >> $S/san2-summary.txt
    rm -rf build/cmake/x86-64-$san-O3
done
echo done >> $S/san2-summary.txt
