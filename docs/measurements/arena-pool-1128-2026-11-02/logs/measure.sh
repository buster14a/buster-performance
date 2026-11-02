#!/bin/bash
set -u
main=/home/david/buster-fast-bench/1128-claude/record/trees/tree-3ce71ec3/build/compiler; head=/home/david/buster-fast-bench/1128-claude/record/trees/tree-d415aa31/build/compiler
C=/home/david/buster-fast-bench/corpus-391e729af658
{ date -u; uname -a; clang --version | head -1; strace --version | head -1; cat /proc/sys/vm/overcommit_memory; cat /sys/kernel/mm/transparent_hugepage/enabled
  for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference)"; done
  sha256sum $main $head; } >> /home/david/buster-fast-bench/1128-claude/record/logs/receipts.txt
[ -f /home/david/buster-fast-bench/1128-claude/record/synth/unit_0.c ] || $main test-check-units --generate /home/david/buster-fast-bench/1128-claude/record/synth > /home/david/buster-fast-bench/1128-claude/record/logs/generate.log 2>&1
(cd /home/david/buster-fast-bench/1128-claude/record/lua && sha256sum *.c *.h > /home/david/buster-fast-bench/1128-claude/record/logs/lua-sources.txt); (cd /home/david/buster-fast-bench/1128-claude/record/synth && sha256sum *.c > /home/david/buster-fast-bench/1128-claude/record/logs/synth-sources.txt); sha256sum $C/sqlite/sqlite3.c >> /home/david/buster-fast-bench/1128-claude/record/logs/receipts.txt
cd /home/david/buster-fast-bench/1128-claude/record/lua
lua=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
lists=(); for n in 1 2 4 8; do lists+=(--list "${lua[@]}" --lanes $n -o /home/david/buster-fast-bench/1128-claude/record/out/lua $(ls *.c)); lists+=(-lm -ldl); done
taskset -c 0-7 $main time-runs --runs 11 --warmups 1 --build main $main --build head $head "${lists[@]}" > /home/david/buster-fast-bench/1128-claude/record/logs/lua.log 2>&1; echo "lua time-runs status $?" >> /home/david/buster-fast-bench/1128-claude/record/logs/receipts.txt
cd /home/david/buster-fast-bench/1128-claude/record/synth
units=$(ls unit_*.c | sort -V)
taskset -c 0-7 $main time-runs --runs 5 --warmups 1 --build main $main --build head $head --list --lanes 1 -o /home/david/buster-fast-bench/1128-claude/record/out/synth $units --list --lanes 8 -o /home/david/buster-fast-bench/1128-claude/record/out/synth $units > /home/david/buster-fast-bench/1128-claude/record/logs/synth.log 2>&1; echo "synth time-runs status $?" >> /home/david/buster-fast-bench/1128-claude/record/logs/receipts.txt
cd /home/david/buster-fast-bench/1128-claude/record
sqlite=(--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
taskset -c 2 $main time-runs --runs 11 --warmups 1 --build main $main --build head $head --list -c -o /home/david/buster-fast-bench/1128-claude/record/out/sqlite3.o "${sqlite[@]}" > /home/david/buster-fast-bench/1128-claude/record/logs/sqlite.log 2>&1; echo "sqlite time-runs status $?" >> /home/david/buster-fast-bench/1128-claude/record/logs/receipts.txt
cd /home/david/buster-fast-bench/1128-claude/record/lua
for b in main head; do for n in 1 4; do
    exe=$main; [ $b = head ] && exe=$head
    taskset -c 0-7 strace -f -c -o /home/david/buster-fast-bench/1128-claude/record/logs/strace-$b-$n.txt $exe "${lua[@]}" --lanes $n -o /home/david/buster-fast-bench/1128-claude/record/out/lua-s $(ls *.c) -lm -ldl; echo "strace $b $n status $?" >> /home/david/buster-fast-bench/1128-claude/record/logs/receipts.txt
done; done
