#!/bin/bash
# startup-timing.sh TAG: under the 9700X's lock, pinned to CPU 2: the post-link step's own run of each MSan
# executable (bake-tables, which a PIE refuses with 77) and test-baked-tables, whole (src) and in parts (split), five
# times each, alternating; then the join's steps on the split ASan tree's checker parts, each timed.
set -u
base=~/buster-fast-bench/2639-claude
out=$base/results/$1
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export OUT="$out" BASE="$base"
~/buster-fast-bench/exclusive.sh timeout -k 10 400 bash -c '
    { date -Is; cat /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/before.txt"
    TIMEFORMAT="%R"
    for round in 1 2 3 4 5; do
        for tree in src split; do
            exe=$BASE/$tree/build/cmake/native-memory-O3/Release/compiler
            t=$( { time taskset -c 2 "$exe" bake-tables "$OUT/baked.tmp" > /dev/null 2>&1; echo "status $?" > "$OUT/status.tmp"; } 2>&1 )
            echo "$round $tree bake-tables $t s $(cat "$OUT/status.tmp")" >> "$OUT/startup.txt"
            t=$( { time taskset -c 2 "$exe" test-baked-tables > /dev/null 2>&1; echo "status $?" > "$OUT/status.tmp"; } 2>&1 )
            echo "$round $tree test-baked-tables $t s $(cat "$OUT/status.tmp")" >> "$OUT/startup.txt"
        done
    done
    rm -f "$OUT/baked.tmp" "$OUT/status.tmp"
    parts=$BASE/split/build/cmake/native-address-O3/Release/codegen/main_unit_checker
    work=$OUT/join; mkdir -p "$work"
    step() { local name=$1; shift; local t; t=$( { time "$@" > "$work/out.txt" 2>&1; } 2>&1 ); echo "$name $t s" >> "$OUT/join-steps.txt"; }
    for p in 0 1 2 3 4 5 6 7 8; do
        step "readelf part$p" llvm-readobj --elf-output-style=GNU -S --wide $parts/part$p.o
        step "objcopy part$p" llvm-objcopy --set-section-flags=.rodata.cst32=alloc,readonly $parts/part$p.o $work/part$p.o
    done
    step "lld -r" ld.lld -r -O0 --threads=1 $work/part0.o $work/part1.o $work/part2.o $work/part3.o $work/part4.o $work/part5.o $work/part6.o $work/part7.o $work/part8.o -o $work/merged.o
    step "nm undefined names" llvm-nm --extern-only --undefined-only --format=just-symbols $work/merged.o
    step "nm undefined posix" llvm-nm --extern-only --undefined-only --format=posix $work/merged.o
    llvm-nm --extern-only --undefined-only --format=just-symbols $work/merged.o > $work/undefined.txt
    step "grep locals" grep -F -x -f $parts/locals.txt $work/undefined.txt
    cat $parts/exports.txt $work/undefined.txt > $work/keep.txt
    step "objcopy keep-global" llvm-objcopy --keep-global-symbols=$work/keep.txt $work/merged.o $work/partial.o
    step "comdat" $BASE/split/build/cmake/native-address-O3/codegen-tools/comdat $work/partial.o $parts/part0.o $parts/part1.o $parts/part2.o $parts/part3.o $parts/part4.o $parts/part5.o $parts/part6.o $parts/part7.o $parts/part8.o
    step "nm defined" llvm-nm --extern-only --defined-only --format=just-symbols $work/partial.o
    step "nm undefined after" llvm-nm --extern-only --undefined-only --format=posix $work/partial.o
    rm -rf "$work"
    { date -Is; cat /proc/loadavg; } > "$OUT/after.txt"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
