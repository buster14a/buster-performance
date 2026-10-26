#!/bin/bash
# pass501c.sh PASS: one pass of #501's confirmation campaign (confirm/), under one hold of the shared lock: as
# pass501.sh, small-threads (41 rounds) and big-threads (10), then on odd passes the one-lane lists and on even passes
# the --time lists, each continuing procbench's rotation from its last pass.
set -u
cd ~/buster-fast-bench/perf-501-claude/confirm
pass=$1
run() {
    local list=$1 rounds=$2 index=$3
    local first=$(( (index - 1) * rounds + 1 ))
    [ -s "results501-$list.tsv" ] || ../procbench --rounds 0 "$list.list" > "results501-$list.tsv"
    ../procbench --first "$first" --rounds "$rounds" --no-header --out out501 "$list.list" >> "results501-$list.tsv"
    echo "$list pass $pass rounds $first-$((first + rounds - 1)) status $? $(date -Is)" >> campaign501.log
}
run small-threads 41 "$pass"
run big-threads 10 "$pass"
if [ $((pass % 2)) -eq 1 ]; then
    run small-one 41 $(( (pass + 1) / 2 ))
    run big-one 10 $(( (pass + 1) / 2 ))
else
    run small-time 41 $(( pass / 2 ))
    run big-time 10 $(( pass / 2 ))
fi
