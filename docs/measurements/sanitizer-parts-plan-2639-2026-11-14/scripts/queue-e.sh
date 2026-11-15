#!/bin/bash
# queue-e.sh: after queue-b, the features and alignment tools (built under the lock, zstd mapped as the build maps it),
# then for each sanitizer's checker: the whole module's alignment table and each part's features, under one hold.
cd ~/buster-fast-bench/2639-claude
while [ ! -e results/queue-b.done ]; do sleep 20; done
llvm=~/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export EXCLUSIVE_OWNER=claude-2639 EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
~/buster-fast-bench/exclusive.sh timeout 120 bash -c "for t in features align; do $llvm/bin/clang -O2 \$($llvm/bin/llvm-config --cflags) tools/\$t.c -o tools/\$t \$($llvm/bin/llvm-config --ldflags --libs bitreader core) \$($llvm/bin/llvm-config --system-libs | sed s,/usr/lib/x86_64-linux-gnu/libzstd.a,-lzstd,) -lstdc++ || exit 1; done" > results/tools-build.log 2>&1
for s in memory address thread; do
    for unit in main_unit_checker main_unit_backend; do
        tree=src/build/cmake/native-$s-O3
        ~/buster-fast-bench/exclusive.sh timeout 600 bash -c "tools/align $tree/CMakeFiles/buster_$unit.dir/Release/src/buster/compiler/$unit.c.o > results/trace-$s-$unit/align.tsv; for f in $tree/Release/codegen/$unit/part[0-7].bc; do p=\${f##*/part}; p=\${p%.bc}; tools/features \$f | awk -v p=\$p 'NR > 1 { print p \"\t\" \$0 }'; done > results/trace-$s-$unit/features.tsv"
    done
done
echo finished > results/queue-e.done
