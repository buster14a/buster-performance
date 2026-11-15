#!/bin/bash
# record2.sh: the second pass, after head's SROA fix (14fb7f83), which changes Tier 1 alone. Each step one exclusive.sh
# hold: head's kernels rebuilt as `head2` (bin/, beside the first pass's); each kernel family's Tier 1 binaries, main's
# and head2's, each perf stat -r 10 (measure-one.sh); each input's Tier 1 compile by main and head, perf stat -r 5
# (compile-one.sh). Tier 0's kernel objects are compared byte for byte with the first pass's head's.
set -euo pipefail
cd ~/buster-fast-bench/2693-claude/harness
mkdir -p record2
export EXCLUSIVE_OWNER=claude-2693 EXCLUSIVE_TITLE="Issue 2693: copy piece shapes, record (second pass)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2693
{
    date -u +%FT%TZ
    for t in main head; do printf '%s: ' $t; git -C ../$t log -1 --format=%H; git -C ../$t status --short; sha256sum ../$t/build/compiler; done
} > record2/receipts.txt
~/buster-fast-bench/exclusive.sh timeout 600 bash -c 'head -1 /var/lib/buster-9700x/owner >> record/holds.txt; ./build-kernels.sh ../head/build/compiler head2'
sha256sum bin/*.head2.t0 bin/*.head2.t1 > record2/binaries.sha256
for k in assign4 assign5 assign6 assign8 assign16 assign32 cold4 cold5 cold6 cold8 cold16 cold32; do
    if cmp -s bin/$k.head.t0.o bin/$k.head2.t0.o; then echo "$k t0 same"; else echo "$k t0 DIFFERS"; fi
done > record2/tier0-objects.txt
: > record2/kernels.tsv
for family in assign cold; do
    list=()
    for n in 4 5 6 8 16 32; do list+=(bin/$family$n.main.t1 bin/$family$n.head2.t1); done
    ~/buster-fast-bench/exclusive.sh timeout 600 bash -c 'for b in "$@"; do ./measure-one.sh "$b"; done' _ "${list[@]}" >> record2/kernels.tsv
done
: > record2/compile.tsv
for input in sqlite main; do
    ~/buster-fast-bench/exclusive.sh timeout 600 bash -c 'for t in main head; do ./compile-one.sh $t "$1" t1; done' _ $input >> record2/compile.tsv
done
echo done > record2/record.done
