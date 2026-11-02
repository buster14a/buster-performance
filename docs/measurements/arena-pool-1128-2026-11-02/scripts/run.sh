#!/bin/bash
# The record's run (#1128): builds main's and the head's trees, each in a hold of the 9700X's lock, then in one more
# hold measures them interleaved (time-runs): Lua 5.4.8's 33 units linked by --lanes 1, 2, 4 and 8 and synth's 512
# units by --lanes 1 and 8 on CPUs 0-7, the frozen sqlite3.c by -c alone on CPU 2, and each build's system calls
# (strace -c) on Lua by 1 and 4 lanes. Logs into logs/; writes logs/done at its end.
set -u
R=$HOME/buster-fast-bench/1128-claude/record
MAIN=tree-3ce71ec3; HEAD=tree-d415aa31
L=$R/logs; mkdir -p $L $R/out
lock() { EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE="solve #1128 record" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1128 ~/buster-fast-bench/exclusive.sh "$@"; }
for t in $MAIN $HEAD; do
    (cd $R/trees/$t && find . -type f ! -name COMMIT ! -path './build/*' -print0 | sort -z | xargs -0 sha256sum > $L/host-manifest-${t#tree-}.txt)
    cmp -s $L/host-manifest-${t#tree-}.txt $R/trees/manifest-${t#tree-}.txt && echo "$t: manifest matches $(cat $R/trees/$t/COMMIT)" >> $L/receipts.txt || echo "$t: MANIFEST DIFFERS" >> $L/receipts.txt
    (cd $R/trees/$t && lock env BUSTER_DEBUG_INFO=0 ./build.sh > $L/build-${t#tree-}.log 2>&1; echo "$t build status $?" >> $L/receipts.txt)
done
cat > $L/measure.sh <<INNER
#!/bin/bash
set -u
main=$R/trees/$MAIN/build/compiler; head=$R/trees/$HEAD/build/compiler
C=$HOME/buster-fast-bench/corpus-391e729af658
{ date -u; uname -a; clang --version | head -1; strace --version | head -1; cat /proc/sys/vm/overcommit_memory; cat /sys/kernel/mm/transparent_hugepage/enabled
  for c in 0 1 2 3 4 5 6 7; do echo "cpu\$c \$(cat /sys/devices/system/cpu/cpu\$c/cpufreq/scaling_governor) \$(cat /sys/devices/system/cpu/cpu\$c/cpufreq/energy_performance_preference)"; done
  sha256sum \$main \$head; } >> $L/receipts.txt
[ -f $R/synth/unit_0.c ] || \$main test-check-units --generate $R/synth > $L/generate.log 2>&1
(cd $R/lua && sha256sum *.c *.h > $L/lua-sources.txt); (cd $R/synth && sha256sum *.c > $L/synth-sources.txt); sha256sum \$C/sqlite/sqlite3.c >> $L/receipts.txt
cd $R/lua
lua=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
lists=(); for n in 1 2 4 8; do lists+=(--list "\${lua[@]}" --lanes \$n -o $R/out/lua \$(ls *.c)); lists+=(-lm -ldl); done
taskset -c 0-7 \$main time-runs --runs 11 --warmups 1 --build main \$main --build head \$head "\${lists[@]}" > $L/lua.log 2>&1; echo "lua time-runs status \$?" >> $L/receipts.txt
cd $R/synth
units=\$(ls unit_*.c | sort -V)
taskset -c 0-7 \$main time-runs --runs 5 --warmups 1 --build main \$main --build head \$head --list --lanes 1 -o $R/out/synth \$units --list --lanes 8 -o $R/out/synth \$units > $L/synth.log 2>&1; echo "synth time-runs status \$?" >> $L/receipts.txt
cd $R
sqlite=(--predefines \$C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem \$C/headers/usr/lib/clang/23/include -isystem \$C/headers/usr/local/include -isystem \$C/headers/usr/include \$C/sqlite/sqlite3.c)
taskset -c 2 \$main time-runs --runs 11 --warmups 1 --build main \$main --build head \$head --list -c -o $R/out/sqlite3.o "\${sqlite[@]}" > $L/sqlite.log 2>&1; echo "sqlite time-runs status \$?" >> $L/receipts.txt
cd $R/lua
for b in main head; do for n in 1 4; do
    exe=\$main; [ \$b = head ] && exe=\$head
    taskset -c 0-7 strace -f -c -o $L/strace-\$b-\$n.txt \$exe "\${lua[@]}" --lanes \$n -o $R/out/lua-s \$(ls *.c) -lm -ldl; echo "strace \$b \$n status \$?" >> $L/receipts.txt
done; done
INNER
chmod +x $L/measure.sh
lock $L/measure.sh > $L/measure-hold.log 2>&1; echo "measure hold status $?" >> $L/receipts.txt
touch $L/done
