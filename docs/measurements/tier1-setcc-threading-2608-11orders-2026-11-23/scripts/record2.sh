#!/bin/bash
# record2.sh: record.sh's stages after the link (record.sh build, then record.sh link, ran first), with 11 of its 33
# orders timed (k = 0, 3, ..., 30): one hold per order waited about ten minutes in the 9700X's queue. The perf record
# data is kept. record.sh: buster#2608's setcc form on the 9700X. Both trees' Release builds (BUSTER_DEBUG_INFO=0); each tree's
# --tier1 compiles Lua 5.4.8's 33 sources once (-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX
# -fno-asynchronous-unwind-tables) and links them in 33 orders, rotation k of the source list (k = 0..32), with -lm -ldl:
# luaV_execute's address moves with each order. Each order's two builds' outputs of #138's five scripts are compared
# once; then per order one hold: both builds (alternating which goes first) under perf stat (3 runs of each script, user
# counters, CPU 2), then perf record of the five scripts (cycles:u, period 100003) for luaV_execute's own cycles.
# Then the compile cost: lvm.c (Lua's flags) and sqlite3.c (--tier1 -O2), each by --lanes 1 -c, 11 alternating runs a tree.
# Every step is one exclusive.sh hold, whose first act appends the holder's line to record/holds.txt.
set -uo pipefail
H=/tmp/2608-setcc-claude/harness
cd $H
mkdir -p record bin objs
rm -f record/record.done record/record.failed
export EXCLUSIVE_OWNER=claude-2608-setcc EXCLUSIVE_TITLE="#2608 setcc form: Tier 1 threading" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2608
X=~/buster-fast-bench/exclusive.sh
LUA=~/buster-fast-bench/138-tier1-quality-claude/inputs/lua-5.4.8/src
SCRIPTS=~/buster-fast-bench/138-tier1-quality-claude/inputs/scripts
SOURCES=(lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua)
FLAGS="--tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
trees=(base head)
stage=${1:-all}
if [ "$stage" = all ] || [ "$stage" = outputs ]; then
    "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; for s in arithmetic calls closures strings tables; do for t in base head; do (cd /tmp && '"$H"'/bin/lua-$t-0 '"$SCRIPTS"'/$s.lua > '"$H"'/record/out-$t-$s.txt 2>&1; echo "status $?" >> '"$H"'/record/out-$t-$s.txt); done; done'
    for s in arithmetic calls closures strings tables; do
        cmp -s record/out-base-$s.txt record/out-head-$s.txt && echo "$s same" >> record/outputs.txt || echo "$s DIFFERS" >> record/outputs.txt
    done
    {
        date -u +%FT%TZ; uname -a; perf --version
        for f in scaling_governor energy_performance_preference; do printf 'cpu2 %s: %s\n' $f "$(cat /sys/devices/system/cpu/cpu2/cpufreq/$f)"; done
        for t in "${trees[@]}"; do printf '%s: ' $t; cat ../$t/COMMIT; sha256sum ../$t/build/compiler; done
        sha256sum scripts/* sqlite3.c bin/lua-* $SCRIPTS/*.lua
    } > record/receipts.txt
fi
if [ "$stage" = all ] || [ "$stage" = time ]; then
    for k in $(seq 0 3 30); do
        if [ $((k / 3 % 2)) = 0 ]; then order="base head"; else order="head base"; fi
        "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; k=$1; shift; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# $k /" >> record/busy.txt
            for t in "$@"; do
                for s in arithmetic calls closures strings tables; do
                    printf "%s\t%s\t%s\t" $t $k $s; (cd /tmp && perf stat -x, -r 3 -e cycles:u,instructions:u,task-clock taskset -c 2 '"$H"'/bin/lua-$t-$k '"$SCRIPTS"'/$s.lua 2>&1 >/dev/null) | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"
                done >> record/runs.tsv
            done
            for t in "$@"; do
                (cd /tmp && perf record -q -e cycles:u -c 100003 -o '"$H"'/record/perf-$t-$k.data -- taskset -c 2 bash -c "for s in arithmetic calls closures strings tables; do '"$H"'/bin/lua-$t-$k '"$SCRIPTS"'/\$s.lua > /dev/null; done" > /dev/null 2>&1)
                perf report -i record/perf-$t-$k.data --stdio -s sym -F period,sym 2>/dev/null | awk -v t=$t -v k=$k "/luaV_execute\$/ { e = \$1 } / \\[\\.\\] / { all += \$1 } END { printf \"%s\t%s\t%s\t%s\n\", t, k, e, all }" >> record/execute.tsv
            done' _ $k $order
    done
fi
if [ "$stage" = all ] || [ "$stage" = cost ]; then
    "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# cost /" >> record/busy.txt; for r in $(seq 11); do for t in base head; do printf "%s\t%s\tlvm\t" $t $r; perf stat -x, -e cycles:u,instructions:u,task-clock taskset -c 2 ../$t/build/compiler '"$FLAGS"' --lanes 1 -c '"$LUA"'/lvm.c -o /tmp/2608-setcc-lvm.o 2>&1 >/dev/null | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"; printf "%s\t%s\tsqlite\t" $t $r; perf stat -x, -e cycles:u,instructions:u,task-clock taskset -c 2 ../$t/build/compiler --tier1 -O2 --lanes 1 -c sqlite3.c -o /tmp/2608-setcc-sqlite.o 2>&1 >/dev/null | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"; done; done > record/cost.tsv; rm -f /tmp/2608-setcc-lvm.o /tmp/2608-setcc-sqlite.o'
fi
echo done > record/record.done
