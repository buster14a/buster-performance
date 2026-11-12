#!/bin/bash
# rerun.sh CORPUS LANES RUNS ROUND: one row of the record's baseline (baseline3.sh, unchanged) inside this one hold of
# the lock, with the busiest processes listed just before and just after it, and the hold's own owner line.
# Results go to results/ROUND/CORPUS-LANES.
set -u
cd "$(dirname "$0")"
name=${1:?a corpus}; lanes=${2:?1 or 8}; runs=${3:?runs}; round=${4:?a round}
out=results/$round/$name-$lanes
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/hold.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12 > "$out/ps-before.txt"
cat /proc/loadavg > "$out/loadavg-before.txt"
./baseline3.sh "$name" "$lanes" "$runs"
status=$?
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12 > "$out/ps-after.txt"
cat /proc/loadavg > "$out/loadavg-after.txt"
mv results/baseline3/"$name-$lanes"/* "$out"/ && mv results/baseline3/"$name-$lanes"/.done "$out"/ 2>/dev/null
rmdir results/baseline3/"$name-$lanes"
echo "rerun exit $status" > "$out/status.txt"
exit $status
