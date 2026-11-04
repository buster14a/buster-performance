#!/bin/bash
# #1233 E1's runner: the executables and inputs, the host's receipts, then e1.sh's two holds of the lock.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs
echo $$ > $R/e1-run.pid
export EXCLUSIVE_OWNER=claude-1233 EXCLUSIVE_TITLE="#1233 cycles without instructions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1233
mkdir -p $R/bin/M $R/bin/H $R/bin/A $R/bin/B $R/inputs/lua
cp $R/trees/tree-754475d4/build/compiler $R/bin/M/compiler
cp $R/trees/tree-4670b2eb/build/compiler $R/bin/H/compiler
cp $R/trees/tree-754475d4/build/compiler $R/bin/A/compiler
cp $R/trees/tree-4670b2eb/build/compiler $R/bin/B/compiler
printf 'int main(void)\n{\n    return 0;\n}\n' > $R/inputs/tiny.c
cp ~/buster-fast-bench/1128-claude/record/lua/*.c ~/buster-fast-bench/1128-claude/record/lua/*.h $R/inputs/lua/
rm -f $R/inputs/lua/luac.c
{ date -u; uname -a; clang --version | head -1; perf --version; cat /sys/kernel/mm/transparent_hugepage/enabled
  for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference)"; done
  sha256sum $R/bin/*/compiler $R/inputs/tiny.c; echo "lua files: $(ls $R/inputs/lua/*.c | wc -l) .c"; (cd $R/inputs/lua && sha256sum *.c *.h); } >> $L/receipts.txt
~/buster-fast-bench/exclusive.sh $R/e1.sh tiny > $L/e1-tiny-hold.log 2>&1; echo "e1 tiny hold status $?" >> $L/receipts.txt
sleep 30
~/buster-fast-bench/exclusive.sh $R/e1.sh lua > $L/e1-lua-hold.log 2>&1; echo "e1 lua hold status $?" >> $L/receipts.txt
echo done > $L/e1-done
