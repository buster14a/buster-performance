#!/bin/bash
k=$1; cd ~/buster-fast-bench/3311-claude
export EXCLUSIVE_OWNER=claude-3311 EXCLUSIVE_TITLE="buster #3311: Tier 1 register-passed structs" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3311
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c "cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; ./time.sh 11 bin/$k.clang-O0 bin/$k.clang-O2 bin/$k.base-tier0 bin/$k.base-tier1 bin/$k.fix-tier0 bin/$k.fix-tier1; cat /proc/loadavg" > times-$k.tsv 2> times-$k.err
echo "$k exit $?" >> one.status
