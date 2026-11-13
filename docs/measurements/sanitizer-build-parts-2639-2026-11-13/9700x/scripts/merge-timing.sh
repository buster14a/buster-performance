#!/bin/bash
# merge-timing.sh TAG: under the 9700X's lock, the join's steps on the split ASan tree's checker parts, timed: the
# section-flag search per part with the join's pattern and a narrowed one, the whole join script, and the post-link
# step's nm of the MSan tree's objects. Into results/TAG.
set -u
base=~/buster-fast-bench/2639-claude
out=$base/results/$1
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export OUT="$out" BASE="$base"
~/buster-fast-bench/exclusive.sh timeout -k 10 300 bash -c '
    { date -Is; cat /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/before.txt"
    tree=$BASE/split/build/cmake/native-address-O3
    parts=$tree/Release/codegen/main_unit_checker
    TIMEFORMAT="%R"
    for narrow in 0 1; do
        for p in 0 1 2 3 4 5 6 7 8; do
            t=$( { time cmake -DOBJECT=$parts/part$p.o -DREADELF=llvm-readobj -DNARROW=$narrow -P $BASE/flags-loop.cmake > "$OUT/flags-$narrow-$p.txt" 2>&1; } 2>&1 )
            echo "narrow=$narrow part$p $t s $(head -c 120 "$OUT/flags-$narrow-$p.txt" | head -1)" >> "$OUT/flags-timing.txt"
        done
    done
    objects=$(ls $parts/part[0-8].o | tr "\n" ";"); objects=${objects%;}
    mkdir -p "$OUT/join"
    t=$( { time cmake "-DOUTPUT=$OUT/join/native.o" "-DEXPORTS=$parts/exports.txt" "-DLOCALS=$parts/locals.txt" "-DOBJECTS=$objects" \
        -DLLD=ld.lld -DOBJCOPY=llvm-objcopy -DNM=llvm-nm -DREADELF=llvm-readobj "-DCOMDAT=$tree/codegen-tools/comdat" \
        -P $BASE/split/cmake/BusterCodegenMerge.cmake > "$OUT/join.log" 2>&1; } 2>&1 )
    echo "join $t s" >> "$OUT/flags-timing.txt"
    cmp "$OUT/join/native.o" "$parts/native.o" >> "$OUT/flags-timing.txt" 2>&1 && echo "join output same as the build'"'"'s" >> "$OUT/flags-timing.txt"
    rm -rf "$OUT/join"
    mtree=$BASE/split/build/cmake/native-memory-O3
    objects=$(find $mtree/Release -name "*.o" -path "*CMakeFiles*" ! -name "main_unit_checker.c.o" ! -name "main_unit_backend.c.o" | sort)
    t=$( { time llvm-nm -u $objects $mtree/Release/codegen/main_unit_checker/native.o $mtree/Release/codegen/main_unit_backend/native.o > /dev/null; } 2>&1 )
    echo "post-link nm -u, MSan split objects: $t s" >> "$OUT/flags-timing.txt"
    t=$( { time llvm-nm -u $mtree/Release/codegen/main_unit_checker/native.o > /dev/null; } 2>&1 )
    echo "nm -u of the MSan checker native.o alone: $t s" >> "$OUT/flags-timing.txt"
    { date -Is; cat /proc/loadavg; } > "$OUT/after.txt"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
