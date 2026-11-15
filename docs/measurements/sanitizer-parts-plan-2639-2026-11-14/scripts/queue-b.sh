#!/bin/bash
# queue-b.sh: after queue-a's builds, the features tool (built under the lock) and each sanitizer's checker and backend
# parts generated at once with -ftime-trace (part-trace.sh), then each part's function features.
cd ~/buster-fast-bench/2639-claude
while [ ! -e results/queue-a.done ]; do sleep 20; done
llvm=~/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export EXCLUSIVE_OWNER=claude-2639 EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
~/buster-fast-bench/exclusive.sh timeout 120 bash -c "$llvm/bin/clang -O2 \$($llvm/bin/llvm-config --cflags) tools/features.c -o tools/features \$($llvm/bin/llvm-config --ldflags --libs bitreader core) \$($llvm/bin/llvm-config --system-libs) -lstdc++" > results/features-build.log 2>&1
for s in memory address thread; do
    for unit in main_unit_checker main_unit_backend; do
        ./part-trace.sh trace-$s-$unit native-$s-O3 $unit
    done
done
for s in memory address thread; do
    for unit in main_unit_checker main_unit_backend; do
        ~/buster-fast-bench/exclusive.sh timeout 600 bash -c "for f in src/build/cmake/native-$s-O3/Release/codegen/$unit/part[0-7].bc; do p=\${f##*/part}; p=\${p%.bc}; tools/features \$f | awk -v p=\$p 'NR > 1 { print p \"\t\" \$0 }'; done > results/trace-$s-$unit/features.tsv; python3 trace-functions.py results/trace-$s-$unit/part*.json > results/trace-$s-$unit/functions.tsv"
    done
done
echo finished > results/queue-b.done
