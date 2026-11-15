#!/bin/bash
# queue-h.sh: after queue-g, the features and alignment tools (built under the lock, LLVM's bitreader and core alone, zstd
# mapped as the build maps it), then for ASan's and TSan's checker in main's tree: each part generated at once with
# -ftime-trace (part-trace.sh), and the whole module's alignment table and each part's features.
cd ~/buster-fast-bench/2639-claude
while [ ! -e results/queue-g.done ]; do sleep 20; done
llvm=~/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export EXCLUSIVE_OWNER=claude-2639 EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
~/buster-fast-bench/exclusive.sh timeout 120 bash -c "for t in features align; do $llvm/bin/clang -O2 \$($llvm/bin/llvm-config --cflags) tools/\$t.c -o tools/\$t \$($llvm/bin/llvm-config --ldflags --libs bitreader core) \$($llvm/bin/llvm-config --system-libs | sed s,/usr/lib/x86_64-linux-gnu/libzstd.a,-lzstd,) -lstdc++ || exit 1; done" > results/tools-build.log 2>&1
for s in address thread memory; do
    unit=main_unit_checker
    tag=trace2-$s-checker
    ./part-trace.sh $tag native-$s-O3 $unit
    tree=src/build/cmake/native-$s-O3
    ~/buster-fast-bench/exclusive.sh timeout 600 bash -c "tools/align $tree/CMakeFiles/buster_$unit.dir/Release/src/buster/compiler/$unit.c.o > results/$tag/align.tsv; for f in $tree/Release/codegen/$unit/part[0-7].bc; do p=\${f##*/part}; p=\${p%.bc}; tools/features \$f | awk -v p=\$p 'NR > 1 { print p \"\t\" \$0 }'; done > results/$tag/features.tsv; python3 trace-functions.py results/$tag/part*.json > results/$tag/functions.tsv; xz -T1 results/$tag/part*.json"
done
echo finished > results/queue-h.done
