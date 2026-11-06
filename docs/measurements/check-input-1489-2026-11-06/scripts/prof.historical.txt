#!/bin/bash
# prof.sh NAME BINARY: cycles:u profile of 8 sq-c compiles on CPU 2 under the lock, then a srcline report.
name=$1; bin=$2
W=~/buster-fast-bench/1489-opencode
cd ~/buster-fast-bench/1340-droid/root || exit 2
SCRATCH=$W/scratch; mkdir -p $SCRATCH $W/prof
source ../repo/tools/microarch/workloads.sh
corpus=corpus
cmd=("$bin" "${COMMON[@]}" "${SQLITE[@]}" -c -o "$SCRATCH/$name-sq.o" --lanes 1)
printf '%q ' "${cmd[@]}" > $W/prof/$name.cmd
EXCLUSIVE_OWNER=opencode-1489 EXCLUSIVE_TITLE="#1489 check-input regression" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1489 \
  ~/buster-fast-bench/exclusive.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $W/prof/holds.txt; LC_ALL=C taskset -c 2 perf record -q -e cycles:u -c 50021 -o $W/prof/$name.data -- bash -c 'for i in 1 2 3 4 5 6 7 8; do $(cat $W/prof/$name.cmd) > /dev/null 2>&1 || exit 1; done'"
echo "record status=$?" > $W/prof/$name.status
LC_ALL=C perf report -i $W/prof/$name.data -n --no-children --sort sym --stdio 2>/dev/null | grep '\[' > $W/prof/$name.syms.txt
LC_ALL=C perf report -i $W/prof/$name.data -n --no-children --sort sym,srcline --stdio 2>/dev/null | grep '\[' > $W/prof/$name.lines.txt
echo "done" >> $W/prof/$name.status
