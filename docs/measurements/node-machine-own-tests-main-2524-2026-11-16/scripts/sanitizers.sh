#!/bin/bash
# run.sh: the sanitizer rows a pull request's checks don't run, for the candidate tree of the tests in the machine's own
# form (/home/user/buster-0003): x86-64 and native, each with memory, address and thread. Each: a Release build as CI's
# rows build it, the part of test-checker with the census's tests (part 5 of 8), and for memory and address the shadow
# with the own form beside the census's code (--verify --front-own-tests) on sqlite3.c, Lua and the compiler's own
# source. Then the native Release build again.
cd /home/user/buster-0003
S=/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad
O=$S/san3
T=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S/corpus/sqlite $S/corpus/sqlite/sqlite3.c"
LUA="$S/corpus/lua/lua-5.4.8/src/*.c"
for row in native:memory native:address native:thread x86-64:memory x86-64:address x86-64:thread; do
    host=${row%%:*}; san=${row#*:}; name=$host-$san
    start=$(date +%s)
    BUSTER_HOST_ARCH=$host BUSTER_SANITIZER=$san BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_LINKER=lld BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $O/build-$name.log 2>&1
    echo "$name build status $? wall $(( $(date +%s) - start )) s" >> $O/progress.txt
    cp build/compiler $O/compiler-$name
    rm -rf $O/reports-$name; mkdir -p $O/reports-$name
    export MSAN_SYMBOLIZER_PATH=$T ASAN_SYMBOLIZER_PATH=$T
    export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$T:log_path=$O/reports-$name/report"
    export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$O/reports-$name/report"
    export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$O/reports-$name/report"
    export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$T:log_path=$O/reports-$name/report"
    export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$T:log_path=$O/reports-$name/report"
    start=$(date +%s)
    $O/compiler-$name test-checker --seed 133 --part 5/8 > $O/part5-$name.out 2> $O/part5-$name.err
    echo "$name part5 status $? wall $(( $(date +%s) - start )) s; $(tail -1 $O/part5-$name.out); reports $(ls $O/reports-$name | wc -l)" >> $O/progress.txt
    if [ $san = memory ] || [ $san = address ]; then
        clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $O/predefines.h
        MAIN="-march=native -Isrc -fwrapv -funsigned-char --predefines $O/predefines.h src/buster/compiler/main.c"
        for unit in sqlite3 lua main; do
            case $unit in main) a=$MAIN ;; sqlite3) a=$SQ ;; lua) a=$LUA ;; esac
            ( start=$(date +%s); $O/compiler-$name measure-node-machine --shadow --verify --front-own-tests --passes 1 $a > $O/shadow-$name-$unit.out 2> $O/shadow-$name-$unit.err; echo "$name shadow $unit status $? wall $(( $(date +%s) - start )) s; reports $(ls $O/reports-$name | wc -l)" >> $O/progress.txt ) &
        done
        wait
    fi
    rm -f $O/compiler-$name
    rm -rf build/cmake/$name-O3
done
./build.sh --config Release > $O/build-native-release.log 2>&1
echo "native release rebuilt status $?" >> $O/progress.txt
echo all done >> $O/progress.txt
