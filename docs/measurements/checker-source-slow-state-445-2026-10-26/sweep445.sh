#!/bin/bash
# sweep445.sh SWEEPS: after campaign445.sh ends, SWEEPS sweeps of sweep445-0.list to sweep445-3.list (32 processes of
# about 1 s each), each list under its own hold of the shared lock, 20 s apart, appended to results445s.tsv; outputs
# in out445s/.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/445
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
while pgrep -f "campaign445.sh 1 16" > /dev/null; do
    sleep 30
done
mkdir -p out445s
[ -s results445s.tsv ] || ./procbench --rounds 0 sweep445-0.list > results445s.tsv
for sweep in $(seq 1 "$1"); do
    for part in 0 1 2 3; do
        ~/buster-fast-bench/exclusive.sh ./procbench --first "$sweep" --rounds 1 --no-header --out out445s "sweep445-$part.list" >> results445s.tsv 2>> sweep445.err
        echo "sweep $sweep part $part status $? $(date -Is)" >> sweep445.log
        sleep 20
    done
done
echo "done $(date -Is)" >> sweep445.log
