#!/bin/bash
# campaign501.sh PASSES: PASSES passes of pass501.sh, each under its own hold of the shared lock (about 70 to 80 s),
# 20 s apart. Status in campaign501.log, the harness's errors in campaign501.err.
set -u
D=~/buster-fast-bench/perf-501-claude
export EXCLUSIVE_OWNER=claude-501
export EXCLUSIVE_TITLE="Solve #501: link-foreign's lane team"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/501
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
mkdir -p out out501
for pass in $(seq 1 "$1"); do
    ~/buster-fast-bench/exclusive.sh ./pass501.sh "$pass" >> campaign501.out 2>> campaign501.err
    echo "pass $pass status $? $(date -Is)" >> campaign501.log
    sleep 20
done
echo "done $(date -Is)" >> campaign501.log
