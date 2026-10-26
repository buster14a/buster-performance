#!/bin/bash
# tmpfs446.sh FIRST LAST: #446's affected case as #424 measured it (tmpfs446.list: no --time, objects and outputs on
# tmpfs), rounds FIRST to LAST after phases446b.sh's, each round under its own hold of the shared lock, appended to
# results446t.tsv. The 2,000-worker program's objects are copied to /tmp/claude-446/objects first.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/446
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
while pgrep -f "phases446" > /dev/null; do sleep 10; done
mkdir -p /tmp/claude-446/objects
cp links2000/buster-link-benchmark-GaN1iP/objects/unit_*.o /tmp/claude-446/objects/
sha256sum links2000/buster-link-benchmark-GaN1iP/objects/unit_*.o | sed 's|links2000/buster-link-benchmark-GaN1iP/objects/||' > tmpfs446-objects.sha256
(cd /tmp/claude-446/objects && sha256sum -c --quiet "$D/tmpfs446-objects.sha256") || { echo "objects differ" >> tmpfs446.log; exit 1; }
[ -s results446t.tsv ] || ./procbench --rounds 0 tmpfs446.list > results446t.tsv
for round in $(seq "$1" "$2"); do
    ~/buster-fast-bench/exclusive.sh ./procbench --first "$round" --rounds 1 --no-header tmpfs446.list >> results446t.tsv 2>> tmpfs446.err
    echo "round $round status $? $(date -Is)" >> tmpfs446.log
    sleep 20
done
echo "done $(date -Is)" >> tmpfs446.log
