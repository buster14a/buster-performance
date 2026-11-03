#!/bin/bash
set -u
main=/home/david/buster-fast-bench/1057-claude/record/trees/tree-754475d4/build/compiler; head=/home/david/buster-fast-bench/1057-claude/record/trees/tree-4670b2eb/build/compiler
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
{ date -u; uname -a; clang --version | head -1; cat /sys/kernel/mm/transparent_hugepage/enabled
  for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference)"; done
  sha256sum $main $head; sha256sum $C/sqlite/sqlite3.c; } >> /home/david/buster-fast-bench/1057-claude/record/logs/receipts.txt
# The tiny file: no header, one function.
printf 'int main(void)\n{\n    return 0;\n}\n' > /home/david/buster-fast-bench/1057-claude/record/inputs/tiny.c
cp /home/david/buster-fast-bench/1057-claude/record/trees/tree-754475d4/tools/ci/changes.c /home/david/buster-fast-bench/1057-claude/record/inputs/changes.c
sha256sum /home/david/buster-fast-bench/1057-claude/record/inputs/tiny.c /home/david/buster-fast-bench/1057-claude/record/inputs/changes.c >> /home/david/buster-fast-bench/1057-claude/record/logs/receipts.txt
runs() { local name=$1; shift; taskset -c 2 $main time-runs --warmups 1 --build main $main --build head $head "$@" > /home/david/buster-fast-bench/1057-claude/record/logs/$name.log 2>&1; echo "$name time-runs status $?" >> /home/david/buster-fast-bench/1057-claude/record/logs/receipts.txt; }
# A tiny file and a small real one: the driver's per-command work, which #1141 moved into check_request_scan and
# check_request_refusal (the same comparisons per argument) and check_request_program_options.
runs tiny --runs 41 --list -c -o /home/david/buster-fast-bench/1057-claude/record/out/tiny-run.o /home/david/buster-fast-bench/1057-claude/record/inputs/tiny.c --list -fsyntax-only /home/david/buster-fast-bench/1057-claude/record/inputs/tiny.c
runs changes --runs 21 --list -c -o /home/david/buster-fast-bench/1057-claude/record/out/changes-run.o /home/david/buster-fast-bench/1057-claude/record/inputs/changes.c
# The representative corpus: the frozen sqlite3.c with its pinned predefines and headers, as the 9700X workflow passes them.
sqlite=(--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
runs sqlite --runs 11 --list -c -o /home/david/buster-fast-bench/1057-claude/record/out/sqlite-run.o "${sqlite[@]}" --list -fsyntax-only "${sqlite[@]}"
# The source benchmarks that share the preparation, as whole processes (their preparation is outside their own timed
# regions, which they print): benchmark-backend-source and benchmark-lowering-source over sqlite3.c.
bench=(--predefines $C/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
runs backend-source --runs 5 --list benchmark-backend-source "${bench[@]}"
runs lowering-source --runs 5 --list benchmark-lowering-source "${bench[@]}"
# The objects, byte for byte: each build's -c of each file.
for b in main head; do exe=$main; [ $b = head ] && exe=$head
    taskset -c 2 $exe -c -o /home/david/buster-fast-bench/1057-claude/record/out/tiny-$b.o /home/david/buster-fast-bench/1057-claude/record/inputs/tiny.c; echo "tiny -c $b status $?" >> /home/david/buster-fast-bench/1057-claude/record/logs/receipts.txt
    taskset -c 2 $exe -c -o /home/david/buster-fast-bench/1057-claude/record/out/changes-$b.o /home/david/buster-fast-bench/1057-claude/record/inputs/changes.c; echo "changes -c $b status $?" >> /home/david/buster-fast-bench/1057-claude/record/logs/receipts.txt
    taskset -c 2 $exe -c -o /home/david/buster-fast-bench/1057-claude/record/out/sqlite-$b.o "${sqlite[@]}"; echo "sqlite -c $b status $?" >> /home/david/buster-fast-bench/1057-claude/record/logs/receipts.txt
done
for f in tiny changes sqlite; do cmp /home/david/buster-fast-bench/1057-claude/record/out/$f-main.o /home/david/buster-fast-bench/1057-claude/record/out/$f-head.o && echo "$f objects identical" >> /home/david/buster-fast-bench/1057-claude/record/logs/receipts.txt || echo "$f OBJECTS DIFFER" >> /home/david/buster-fast-bench/1057-claude/record/logs/receipts.txt; done
sha256sum /home/david/buster-fast-bench/1057-claude/record/out/*-main.o /home/david/buster-fast-bench/1057-claude/record/out/*-head.o >> /home/david/buster-fast-bench/1057-claude/record/logs/receipts.txt
