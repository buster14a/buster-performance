#!/bin/bash
# profile.sh VARIANT EVENT PERIOD: samples EVENT (user) over 3 of sqlite3.c's -c, then the shares by symbol.
cd ~/buster-fast-bench/1555-claude/run || exit 2
source ../main/tools/microarch/workloads.sh
SCRATCH=scratch
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
v=$1; ev=$2; period=$3
workload "$v" sq-c
data=results/profile-$v-${ev//[^a-z0-9]/_}.data
rm -f $data
for i in 1 2 3; do
    perf record -q -e "$ev" -c "$period" -o $data.$i taskset -c 2 "${WL[@]}" > /dev/null 2>&1 || echo "FAILED $i"
done
for i in 1 2 3; do
    perf report -i $data.$i --stdio --no-children --sort symbol 2> /dev/null | grep -v '^#' | grep -v '^$' | head -25 > $data.$i.txt
done
cat $data.1.txt
