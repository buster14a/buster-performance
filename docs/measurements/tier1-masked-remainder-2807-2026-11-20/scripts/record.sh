#!/bin/bash
# record.sh: buster#2807's 9700X run. Both trees' Release builds; buster#2743's kernels.c by each tree's
# --tier1 --tier1-passes=+vectorize -O2 at znver5, linked with short.c (lengths 0 to 257) and with #2743's harness.c
# (8 KB arrays), both by clang -O2; three alternating rounds of each, pinned to CPU 2; then the pass's compile cost on
# sqlite3.c, 11 alternating runs a tree. Every step is one exclusive.sh hold, whose first act appends the holder's
# line to record/holds.txt.
set -uo pipefail
cd ~/buster-fast-bench/2807-claude/harness
mkdir -p record bin
rm -f record/record.done record/record.failed record/holds.txt record/busy.txt
export EXCLUSIVE_OWNER=claude-2807 EXCLUSIVE_TITLE="#2807 AVX-512 masked remainder" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2807
X=~/buster-fast-bench/exclusive.sh
trees=(base head)
for t in "${trees[@]}"; do
    "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; cd ../$1 && BUSTER_DEBUG_INFO=0 ./build.sh --config Release' _ $t > record/build-$t.log 2>&1
    test -x ../$t/build/compiler || { echo "no $t compiler" > record/record.failed; exit 1; }
done
clang -O2 -Wall -Wextra -c src/short.c -o bin/short.o || { echo "short.c" > record/record.failed; exit 1; }
clang -O2 -Wall -Wextra -c src/harness.c -o bin/harness.o || { echo "harness.c" > record/record.failed; exit 1; }
for t in "${trees[@]}"; do
    ../$t/build/compiler --tier1 --tier1-passes=+vectorize --tier1-report --verify -O2 -march=znver5 -c src/kernels.c -o bin/k-$t.o 2> record/report-$t.txt || { echo "kernels $t" > record/record.failed; exit 1; }
    clang -O2 -o bin/short-$t bin/short.o bin/k-$t.o
    clang -O2 -o bin/h-$t bin/harness.o bin/k-$t.o -lm
    size -A bin/k-$t.o > record/size-$t.txt
    objdump -d --no-show-raw-insn bin/k-$t.o > record/k-$t.s
done
{
    date -u +%FT%TZ; uname -a; clang --version | head -1; perf --version
    for f in scaling_governor energy_performance_preference; do printf 'cpu2 %s: %s\n' $f "$(cat /sys/devices/system/cpu/cpu2/cpufreq/$f)"; done
    for t in "${trees[@]}"; do printf '%s: ' $t; git -C ../$t log -1 --format=%H; git -C ../$t status --short | wc -l; sha256sum ../$t/build/compiler; done
    sha256sum src/* scripts/* sqlite3.c bin/short-* bin/h-* bin/k-*.o
} > record/receipts.txt
names=$(sed -n 's/^    { "\([a-z0-9_]*\)", run_.*/\1/p' src/harness.c)
for round in 1 2 3; do
    for t in "${trees[@]}"; do
        "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# $1 short $2 /" >> record/busy.txt; taskset -c 2 ./bin/short-$1 > record/short-$1-$2.tsv' _ $t $round
        "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# $1 long $2 /" >> record/busy.txt; for n in $3; do taskset -c 2 ./bin/h-$1 $n 0; done > record/long-$1-$2.tsv' _ $t $round "$names"
    done
done
"$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4 | sed "s/^/# cost /" >> record/busy.txt; for r in $(seq 11); do for t in base head; do printf "%s\t%s\t" $t $r; perf stat -x, -e cycles:u,instructions:u,task-clock taskset -c 2 ../$t/build/compiler --tier1 --tier1-passes=+vectorize -O2 -march=znver5 --lanes 1 -c sqlite3.c -o /tmp/2807-claude-cost.o 2>&1 >/dev/null | awk -F, "{printf \"%s=%s\t\", \$3, \$1} END {print \"\"}"; done; done > record/cost.tsv; rm -f /tmp/2807-claude-cost.o'
echo done > record/record.done
