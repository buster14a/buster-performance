#!/bin/bash
# #619's part 2 (0cf1abd48c70997d3b5f227ed7668cea96d95892: -c's named sections and file-scope asm, with #700's head merged) against #700's head
# (93d232b80ee4b6d863c3c7d0988572cb6bfdebbd), on the 9700X:
# - each tree's build, under its own hold of the lock;
# - the frozen sqlite3.c's -c object by each, which must be the same, as the unit names no section;
# - main.c with build.sh's flags: -fsyntax-only by the head, and -c by each, whose first refusal moves past the sections;
# - the suites the change reaches, on the head, on CPUs 0 to 7 as the job runs them;
# - perf stat of the frozen sqlite3.c's -fsyntax-only and -c in rotating rounds, of the base, a copy of the base's
#   executable (an A/A control) and the head, and ab's rounds of time-runs of the three;
# - what named sections cost a compile: a generated unit of 20,000 functions and 2,000 variables, plain, and with three
#   quarters of each in named sections, by the head, in rotating rounds;
# - benchmark-object-writer by the base and the head, in turn.
# Every run takes the lock on its own (`locked`), which writes a receipt of when it took and released it and of CPU 2's
# frequency policy then, and runs pinned to CPU 2, but the suites. Nothing is filtered from the logs: the lock's
# waiting messages name the runs it waited for.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #619's named sections in -c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/619
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/ab619s2
export TMPDIR=$here/tmp
export SOURCE_DATE_EPOCH=1792454400
export RECEIPTS=$here/receipts.log
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
main_flags=(-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing)
cd $here
# A receipt line: what, when, and CPU 2's governor, energy preference, frequency bounds and boost.
receipt()
{
    local cpu=/sys/devices/system/cpu/cpu2/cpufreq
    echo "$1 $(date -Ins) governor=$(cat $cpu/scaling_governor) epp=$(cat $cpu/energy_performance_preference) min=$(cat $cpu/scaling_min_freq) max=$(cat $cpu/scaling_max_freq) boost=$(cat /sys/devices/system/cpu/cpufreq/boost) driver=$(cat $cpu/scaling_driver): ${*:2}" >> "$RECEIPTS"
}
export -f receipt
# Runs a command under the lock, with receipts of its acquisition and release.
locked()
{
    $lock bash -c 'receipt acquired "$@"; "$@"; status=$?; receipt "released status=$status" "$@"; exit $status' locked "$@"
}
for tree in base head; do
    (cd $tree && locked env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree: $(grep 'sources compiled' build_$tree.log)"
    (cd $tree && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum) > source-$tree.sha256
done
mkdir -p control/build
cp base/build/compiler control/build/compiler
cmp base/build/compiler control/build/compiler && echo "control is the base's executable"
for tree in base head; do
    locked taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
    locked taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" > drive_$tree.log 2>&1
    echo "drive $tree status $?"
done
cmp lower_base.o lower_head.o && echo "lower objects identical"
(cd head && locked taskset -c 2 ./build/compiler -fsyntax-only "${main_flags[@]}" -Wall -Werror src/buster/compiler/main.c > $here/main_c_check_head.log 2>&1; echo "main.c -fsyntax-only head status $?: $(grep -v '^exclusive.sh:\|^  ' $here/main_c_check_head.log | tail -1)")
for tree in base head; do
    (cd $tree && locked taskset -c 2 ./build/compiler -c -o $here/main_c_$tree.o "${main_flags[@]}" src/buster/compiler/main.c > $here/main_c_lower_$tree.log 2>&1; echo "main.c -c $tree status $?: $(grep -v '^exclusive.sh:\|^  ' $here/main_c_lower_$tree.log | head -1)")
done
cd head
git init -q --template= build/c-testsuite
git -C build/c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
git -C build/c-testsuite checkout -q FETCH_HEAD
run()
{
    local name=$1
    shift
    locked taskset -c 0-7 "$@" > ../test_$name.log 2>&1
    echo "$name status $?: $(grep -v '^exclusive.sh:\|^  ' ../test_$name.log | tail -1)"
}
run test-object-writer ./build/compiler test-object-writer --cross-check
run test-assembler ./build/compiler test-assembler --cross-check
run test-checker ./build/compiler test-checker --seed 133
run test-checker-driver ./build/compiler test-checker-driver --executable ./build/compiler
run test-checker-deferred ./build/compiler test-checker-deferred
run test-check-lanes ./build/compiler test-check-lanes
run test-check-debug ./build/compiler test-check-debug --cross-check
run test-import ./build/compiler test-import --cross-check
run test-c-testsuite ./build/compiler test-c-testsuite --cross-check --clang /usr/bin/clang --jobs 8 --subset tests/c-testsuite/subset.txt build/c-testsuite
run test-corpus-musl ./build/compiler test-checker-corpus --clang /usr/bin/clang --symbols-minimum 354 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe \
    -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" \
    "$musl/src/math" "$musl/src/string" "$musl/src/stdlib" "$musl/src/fenv" "$musl/src/legacy" "$musl/src/process" "$musl/src/signal" "$musl/src/multibyte"
run test-corpus-sqlite ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c"
run benchmark-lowering-source taskset -c 2 ./build/compiler benchmark-lowering-source build/c-testsuite/tests/single-exec/*.c
cd ..
trees=(base control head)
for round in 1 2 3; do
    for i in 0 1 2; do
        tree=${trees[$(((i + round) % 3))]}
        echo "== round $round tree $tree drive" >> perf.log
        locked perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>> perf.log >/dev/null
        echo "== round $round tree $tree lower" >> perf.log
        locked perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>> perf.log >/dev/null
    done
done
echo "perf done"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $here/lock-receipt.sh base control head -- time-runs --runs 11 --list -fsyntax-only "${check[@]}" --list -c -o /dev/null "${lower[@]}" > ab.log 2>&1
echo "ab status $?"
# What named sections cost a compile: 20,000 external functions and 2,000 initialized variables, plain, and with
# every function but each fourth in .text.hot or .text.unlikely and every variable but each fourth in .data.tables,
# by the head, in rotating rounds. Each object is checked to have its sections.
for variant in plain named; do
    {
        for i in $(seq 0 19999); do
            attribute=""
            if [ $variant = named ] && [ $((i % 4)) -ne 3 ]; then
                if [ $((i % 2)) -eq 0 ]; then attribute='__attribute__((section(".text.hot"))) '; else attribute='__attribute__((section(".text.unlikely"))) '; fi
            fi
            printf '%sint f%d(int x) { return x * %d + 1; }\n' "$attribute" $i $i
        done
        for i in $(seq 0 1999); do
            attribute=""
            if [ $variant = named ] && [ $((i % 4)) -ne 3 ]; then attribute='__attribute__((section(".data.tables"))) '; fi
            printf '%sint v%d = %d;\n' "$attribute" $i $((i + 1))
        done
    } > sections_$variant.c
    locked taskset -c 2 head/build/compiler -c -o sections_$variant.o sections_$variant.c > sections_$variant.log 2>&1
    echo "sections $variant status $?: $(readelf -SW sections_$variant.o | grep -c ' \.text\.\| \.data\.tables') named sections"
    readelf -SW sections_$variant.o > sections_$variant.readelf
done
variants=(plain named)
for round in 1 2 3 4; do
    for i in 0 1; do
        variant=${variants[$(((i + round) % 2))]}
        echo "== round $round variant $variant" >> sections_perf.log
        locked perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 head/build/compiler -c -o /dev/null sections_$variant.c 2>> sections_perf.log >/dev/null
    done
done
echo "sections perf done"
for round in 1 2 3 4 5 6; do
    for i in 0 1; do
        tree=$([ $(((i + round) % 2)) -eq 0 ] && echo base || echo head)
        echo "== round $round tree $tree" >> object_writer.log
        (cd $tree && locked taskset -c 2 ./build/compiler benchmark-object-writer >> $here/object_writer.log 2>&1)
    done
done
echo "object writer done"
sha256sum base/build/compiler control/build/compiler head/build/compiler lower_base.o lower_head.o sections_plain.c sections_named.c sections_plain.o sections_named.o "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" > inputs.sha256
uname -r >> inputs.sha256
clang --version | head -1 >> inputs.sha256
echo "all done"
