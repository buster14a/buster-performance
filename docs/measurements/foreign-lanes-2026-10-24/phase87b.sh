#!/bin/bash
# #87: lanes past the CPUs, on tree87 before link-foreign capped its lanes at its CPUs: synth's shape on 15, 16 and 20
# lanes on all 15 online CPUs, three rounds in turned orders, each its own lock acquisition.
base=~/buster-fast-bench/claude-linker-80
log=$base/logs87
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/87
L=~/buster-fast-bench/exclusive.sh
r=0
for order in "15 16 20" "20 16 15" "16 15 20"; do
    r=$((r + 1))
    EXCLUSIVE_TITLE="Issue 87: link-foreign past the CPUs, round $r" $L $base/sweep87.sh $order > $log/over-r$r.log 2>&1; echo "over$r=$? $(date -Is)" >> $log/status
done
echo "over done $(date -Is)" >> $log/status
