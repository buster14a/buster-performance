#!/bin/bash
# record.sh: the record's run (#1375's record.sh's shape, with fewer holds: the 9700X had 25 sessions waiting).
# Receipts; then each step is one exclusive.sh hold of its own, whose first act appends the holder's line to
# record/holds.txt: both trees' kernel builds; each kernel's five binaries (main and head by Tier 0 and Tier 1, and
# clang -O0), each perf stat -r 10 (measure-one.sh); each input's and tier's compile by main and head, each perf stat
# -r 5 (compile-one.sh). Every timeout is inside its hold; measure-one.sh and compile-one.sh append the holder's line for
# each of their runs too.
set -euo pipefail
cd ~/buster-fast-bench/2693-claude/harness
mkdir -p record
rm -f record/record.done record/holds.txt
export EXCLUSIVE_OWNER=claude-2693 EXCLUSIVE_TITLE="Issue 2693: copy piece shapes, record" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2693
trees=(${TREES:-main head})
{
    date -u +%FT%TZ; uname -a; clang --version | head -1; perf --version
    for f in scaling_governor energy_performance_preference; do printf 'cpu2 %s: %s\n' $f "$(cat /sys/devices/system/cpu/cpu2/cpufreq/$f)"; done
    for t in "${trees[@]}"; do printf '%s: ' $t; git -C ../$t log -1 --format=%H; git -C ../$t status --short; sha256sum ../$t/build/compiler; done
    sha256sum sqlite3.c *.c *.sh
} > record/receipts.txt
rm -rf bin
~/buster-fast-bench/exclusive.sh timeout 600 bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; for t in "$@"; do ./build-kernels.sh ../$t/build/compiler $t; done' _ "${trees[@]}"
sha256sum bin/* | grep -v '\.o$' > record/binaries.sha256
: > record/kernels.tsv
for k in assign4 assign5 assign6 assign8 assign16 assign32 cold4 cold5 cold6 cold8 cold16 cold32; do
    list=()
    for t in "${trees[@]}"; do list+=(bin/$k.$t.t0); done
    for t in "${trees[@]}"; do list+=(bin/$k.$t.t1); done
    list+=(bin/$k.clang)
    ~/buster-fast-bench/exclusive.sh timeout 600 bash -c 'for b in "$@"; do ./measure-one.sh "$b"; done' _ "${list[@]}" >> record/kernels.tsv
done
: > record/compile.tsv
for input in sqlite main; do for tier in t0 t1; do
    ~/buster-fast-bench/exclusive.sh timeout 600 bash -c 'for t in "${@:3}"; do ./compile-one.sh $t "$1" "$2"; done' _ $input $tier "${trees[@]}" >> record/compile.tsv
done; done
echo done > record/record.done
