#!/bin/bash
# record.sh: #2820's 9700X run. The two trees' Release builds, receipts, then each kernel binary (Tier 0, Tier 1 by
# each tree, clang -O0) measured by measure-one.sh and the compile timings, each step one exclusive.sh hold whose first
# act appends the holder's line to record/holds.txt.
set -uo pipefail
cd ~/buster-fast-bench/2820-claude/harness
mkdir -p record
rm -f record/record.done record/holds.txt record/busy.txt
export EXCLUSIVE_OWNER=claude-2820 EXCLUSIVE_TITLE="#2820 forwarded hidden pointer in rdi" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2820
X=~/buster-fast-bench/exclusive.sh
trees=(base head)
for t in "${trees[@]}"; do
    "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; cd ../$1 && BUSTER_DEBUG_INFO=0 ./build.sh --config Release' _ $t > record/build-$t.log 2>&1
    test -x ../$t/build/compiler || { echo "no $t compiler" > record/record.failed; exit 1; }
done
{
    date -u +%FT%TZ; uname -a; clang --version | head -1; perf --version
    for f in scaling_governor energy_performance_preference; do printf 'cpu2 %s: %s\n' $f "$(cat /sys/devices/system/cpu/cpu2/cpufreq/$f)"; done
    for t in "${trees[@]}"; do printf '%s: ' $t; git -C ../$t log -1 --format=%H; git -C ../$t status --short | wc -l; sha256sum ../$t/build/compiler; done
    sha256sum sqlite3.c *.c *.sh
} > record/receipts.txt
rm -rf bin
for t in "${trees[@]}"; do "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ./build-kernels.sh "$1" "$2"' _ ../$t/build/compiler $t > record/kernels-$t.log 2>&1; done
sha256sum bin/* | grep -v '\.o$' > record/binaries.sha256
list=()
for k in forward3 forward8 forward64 named8 named64; do list+=(bin/$k.base.t1 bin/$k.head.t1 bin/$k.base.t0 bin/$k.clang); done
: > record/kernels.tsv
for round in 1 2; do for b in "${list[@]}"; do "$X" ./measure-one.sh "$b" | sed "s/^/$round\t/" >> record/kernels.tsv; done; done
: > record/compile.tsv
for tier in t1 t0; do for t in "${trees[@]}"; do
    "$X" ./compile-one.sh $t sqlite $tier >> record/compile.tsv
done; done
echo done > record/record.done
