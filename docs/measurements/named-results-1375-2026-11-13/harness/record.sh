#!/bin/bash
# record.sh: the record's run. Receipts (host, tools, trees, binaries); then every build, measured binary and compile
# timing is one exclusive.sh hold of its own, whose first act appends the holder's line to record/holds.txt.
set -euo pipefail
cd ~/buster-fast-bench/1375-claude/harness
mkdir -p record
echo $$ > record/record.pid
rm -f record/record.done record/holds.txt
export EXCLUSIVE_OWNER=claude-1375 EXCLUSIVE_TITLE="#1375 NRVO record" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1375
trees=(main nrvo narrow)
{
    date -u +%FT%TZ; uname -a; clang --version | head -1; perf --version
    for f in scaling_governor energy_performance_preference; do printf 'cpu2 %s: %s\n' $f "$(cat /sys/devices/system/cpu/cpu2/cpufreq/$f)"; done
    for t in "${trees[@]}"; do printf '%s: ' $t; git -C ../$t log -1 --format=%H; git -C ../$t status --short; sha256sum ../$t/build/compiler; done
    git -C ../narrow diff -- src/buster/compiler/tier0.c
    sha256sum sqlite3.c *.c *.sh
} > record/receipts.txt
rm -rf bin
for t in "${trees[@]}"; do ~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ./build-kernels.sh "$1" "$2"' _ ../$t/build/compiler $t; done
sha256sum bin/* | grep -v '\.o$' > record/binaries.sha256
list=()
for k in k24 k16 k64; do list+=(bin/$k.main.t0 bin/$k.nrvo.t0 bin/$k.main.t1 bin/$k.nrvo.t1 bin/$k.clang); done
for k in assign8 assign16 assign32 cold8 cold16 cold32; do list+=(bin/$k.main.t0 bin/$k.nrvo.t0 bin/$k.narrow.t0 bin/$k.nrvo.t1 bin/$k.clang); done
: > record/kernels.tsv
for b in "${list[@]}"; do ~/buster-fast-bench/exclusive.sh ./measure-one.sh "$b" >> record/kernels.tsv; done
: > record/compile.tsv
for input in sqlite main; do for tier in t0 t1; do for t in main nrvo; do
    ~/buster-fast-bench/exclusive.sh ./compile-one.sh $t $input $tier >> record/compile.tsv
done; done; done
echo done > record/record.done
