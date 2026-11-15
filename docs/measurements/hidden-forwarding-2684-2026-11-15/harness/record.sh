#!/bin/bash
# record.sh: the record's run. The trees' Release builds, receipts (host, tools, trees, binaries); then every build,
# measured binary and compile timing is one exclusive.sh hold of its own, whose first act appends the holder's line
# to record/holds.txt.
set -uo pipefail
cd ~/buster-fast-bench/2684-claude/harness
mkdir -p record
echo $$ > record/record.pid
rm -f record/record.done record/holds.txt record/busy.txt
export EXCLUSIVE_OWNER=claude-2684 EXCLUSIVE_TITLE="#2684 forwarded results record" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2684
X=~/buster-fast-bench/exclusive.sh
trees=(main head)
for t in "${trees[@]}"; do
    "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; cd ../$1 && ./build.sh --config Release' _ $t > record/build-$t.log 2>&1
    test -x ../$t/build/compiler || { echo "no $t compiler" > record/record.failed; exit 1; }
done
{
    date -u +%FT%TZ; uname -a; clang --version | head -1; perf --version
    for f in scaling_governor energy_performance_preference; do printf 'cpu2 %s: %s\n' $f "$(cat /sys/devices/system/cpu/cpu2/cpufreq/$f)"; done
    for t in "${trees[@]}"; do printf '%s: ' $t; git -C ../$t log -1 --format=%H; git -C ../$t status --short | wc -l; sha256sum ../$t/build/compiler; done
    sha256sum ../head.patch sqlite3.c *.c *.sh
} > record/receipts.txt
rm -rf bin
for t in "${trees[@]}"; do "$X" bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ./build-kernels.sh "$1" "$2"' _ ../$t/build/compiler $t > record/kernels-$t.log 2>&1; done
sha256sum bin/* | grep -v '\.o$' > record/binaries.sha256
list=()
for k in forward3 forward8 forward64 named8 named64; do list+=(bin/$k.main.t0 bin/$k.head.t0 bin/$k.main.t1 bin/$k.head.t1 bin/$k.clang); done
: > record/kernels.tsv
for b in "${list[@]}"; do "$X" ./measure-one.sh "$b" >> record/kernels.tsv; done
: > record/compile.tsv
for input in sqlite main; do for tier in t0 t1; do for t in "${trees[@]}"; do
    "$X" ./compile-one.sh $t $input $tier >> record/compile.tsv
done; done; done
echo done > record/record.done
