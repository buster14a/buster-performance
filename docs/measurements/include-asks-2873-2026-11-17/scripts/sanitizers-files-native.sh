#!/bin/bash
# sanitizers-files.sh TREE OUT: the sanitizer rows a pull request's checks don't run, for a change to the include
# search, in the worktree TREE (at the commit under test): memory, address and thread on the x86-64 host and on the
# native one. Each row: a Release build as CI's rows build it, test-preprocessor (its four parts) and test-files, and
# for memory and address -c of a unit with only <stdio.h> and of sqlite3.c. Progress is OUT/progress.txt; a report is a
# file under OUT/reports-ROW.
set -u
tree=$1; out=$2
cd "$tree" || exit 1
mkdir -p "$out"
. /home/user/keep/corpora.sh
symbolizer=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer
printf '#include <stdio.h>\nint main(void)\n{\n    puts("hello");\n    return 0;\n}\n' > "$out/hello.c"
for row in native:memory native:address native:thread; do
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
    for part in 1 2 3 4; do
        start=$(date +%s)
        "$out/compiler-$name" test-preprocessor --part $part/4 > "$out/preprocessor-$name-$part.out" 2> "$out/preprocessor-$name-$part.err"
        echo "$name test-preprocessor part $part/4 status $? wall $(( $(date +%s) - start )) s; asks line: $(grep -c 'directory asks: as expected' "$out/preprocessor-$name-$part.out"); reports $(ls "$reports" | wc -l)" >> "$out/progress.txt"
    done
    start=$(date +%s)
    "$out/compiler-$name" test-files > "$out/files-$name.out" 2> "$out/files-$name.err"
    echo "$name test-files status $? wall $(( $(date +%s) - start )) s; $(tail -1 "$out/files-$name.out"); reports $(ls "$reports" | wc -l)" >> "$out/progress.txt"
    if [ "$san" = memory ] || [ "$san" = address ]; then
        "$out/compiler-$name" -c "$out/hello.c" -o "$out/hello-$name.o" > "$out/hello-$name.out" 2>&1
        echo "$name -c hello.c status $?; reports $(ls "$reports" | wc -l)" >> "$out/progress.txt"
        bash -c "$out/compiler-$name -c $sqlite_arguments -o $out/sqlite-$name.o" > "$out/sqlite-$name.out" 2>&1
        echo "$name -c sqlite3.c status $?; reports $(ls "$reports" | wc -l)" >> "$out/progress.txt"
        rm -f "$out/hello-$name.o" "$out/sqlite-$name.o"
    fi
    rm -f "$out/compiler-$name"
done
echo "all done" >> "$out/progress.txt"
