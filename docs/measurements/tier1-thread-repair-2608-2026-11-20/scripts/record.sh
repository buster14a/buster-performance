#!/bin/bash
# record.sh: buster#2608's 9700X run. Both trees' Release builds; Lua 5.4.8's interpreter by each tree's --tier1 as
# measure-tier1-programs builds it (its 33 sources, -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX
# -fno-asynchronous-unwind-tables, -lm -ldl); each of #138's five scripts' output compared between the builds; then five
# alternating rounds of each build's five scripts under perf stat (3 runs each, user counters, CPU 2); then the compile
# cost: Lua's build command and sqlite3.c's --tier1 -c, one lane, 11 alternating runs a tree. Every step is one
# exclusive.sh hold, whose first act appends the holder's line to record/holds.txt.
set -uo pipefail
cd ~/buster-fast-bench/2608-claude/harness
mkdir -p record bin
rm -f record/record.done record/record.failed record/holds.txt record/busy.txt
export EXCLUSIVE_OWNER=claude-2608 EXCLUSIVE_TITLE="#2608 threading past the test with an SSA repair" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2608
X=~/buster-fast-bench/exclusive.sh
LUA=~/buster-fast-bench/138-tier1-quality-claude/inputs/lua-5.4.8/src
SCRIPTS=~/buster-fast-bench/138-tier1-quality-claude/inputs/scripts
SOURCES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
paths=""; for s in $SOURCES; do paths="$paths $LUA/$s.c"; done
export paths
trees=(base head)
for t in "${trees[@]}"; do
    "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; cd ../$1 && BUSTER_DEBUG_INFO=0 ./build.sh --config Release' _ $t > record/build-$t.log 2>&1
    test -x ../$t/build/compiler || { echo "no $t compiler" > record/record.failed; exit 1; }
done
for t in "${trees[@]}"; do
    "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ../$1/build/compiler --tier1 -fno-asynchronous-unwind-tables --tier1-report -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o bin/lua-$1 $paths -lm -ldl 2> record/lua-report-$1.txt' _ $t
    test -x bin/lua-$t || { echo "no $t lua" > record/record.failed; exit 1; }
    size -A bin/lua-$t > record/size-lua-$t.txt
done
for s in arithmetic calls closures strings tables; do
    for t in "${trees[@]}"; do
        "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; cd /tmp && taskset -c 2 ~/buster-fast-bench/2608-claude/harness/bin/lua-$1 '"$SCRIPTS"'/$2.lua > ~/buster-fast-bench/2608-claude/harness/record/out-$1-$2.txt 2>&1; echo "status $?" >> ~/buster-fast-bench/2608-claude/harness/record/out-$1-$2.txt' _ $t $s
    done
    cmp -s record/out-base-$s.txt record/out-head-$s.txt && echo "$s same" >> record/outputs.txt || echo "$s DIFFERS" >> record/outputs.txt
done
{
    date -u +%FT%TZ; uname -a; clang --version | head -1; perf --version
    for f in scaling_governor energy_performance_preference; do printf 'cpu2 %s: %s\n' $f "$(cat /sys/devices/system/cpu/cpu2/cpufreq/$f)"; done
    for t in "${trees[@]}"; do printf '%s: ' $t; git -C ../$t log -1 --format=%H; git -C ../$t status --short | wc -l; sha256sum ../$t/build/compiler; done
    sha256sum scripts/* sqlite3.c bin/lua-* $SCRIPTS/*.lua
} > record/receipts.txt
for round in 1 2 3 4 5; do
    for t in "${trees[@]}"; do
        "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# $1 run $2 /" >> record/busy.txt; for s in arithmetic calls closures strings tables; do printf "%s\t%s\t%s\t" $1 $2 $s; (cd /tmp && perf stat -x, -r 3 -e cycles:u,instructions:u,task-clock taskset -c 2 ~/buster-fast-bench/2608-claude/harness/bin/lua-$1 '"$SCRIPTS"'/$s.lua 2>&1 >/dev/null) | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"; done >> record/runs.tsv' _ $t $round
    done
done
"$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# cost /" >> record/busy.txt; for r in $(seq 11); do for t in base head; do printf "%s\t%s\tlua\t" $t $r; perf stat -x, -e cycles:u,instructions:u,task-clock taskset -c 2 ../$t/build/compiler --tier1 -fno-asynchronous-unwind-tables --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o /tmp/2608-claude-lua $paths -lm -ldl 2>&1 >/dev/null | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"; printf "%s\t%s\tsqlite\t" $t $r; perf stat -x, -e cycles:u,instructions:u,task-clock taskset -c 2 ../$t/build/compiler --tier1 -O2 --lanes 1 -c sqlite3.c -o /tmp/2608-claude-sqlite.o 2>&1 >/dev/null | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"; done; done > record/cost.tsv; rm -f /tmp/2608-claude-lua /tmp/2608-claude-sqlite.o'
echo done > record/record.done
