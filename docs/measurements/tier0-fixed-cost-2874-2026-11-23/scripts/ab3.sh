#!/bin/bash
# Usage: ab3.sh TAG ROUNDS NAME=BINARY...: -c sqlite3.c --time-stages by each binary, ROUNDS rounds, the order rotated
# a place every round, CPU 2 (buster#2874). The caller holds the lock for the script.
set -u
D=~/buster-fast-bench/2874-claude-volta
C=$D/corpus
TAG=$1; ROUNDS=$2; shift 2
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
NAMES=(); BINS=()
for spec in "$@"; do NAMES+=("${spec%%=*}"); BINS+=("${spec#*=}"); mkdir -p $D/results/$TAG/${spec%%=*}; done
N=${#NAMES[@]}
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
: > objects.txt; : > order.txt
for i in $(seq 1 $ROUNDS); do
  for k in $(seq 0 $((N - 1))); do
    j=$(( (i + k) % N ))
    echo "$i ${NAMES[$j]}" >> order.txt
    taskset -c 2 ${BINS[$j]} -c $FLAGS $C/sqlite/sqlite3.c -o /dev/shm/2874-volta-$TAG.o --time-stages 2> ${NAMES[$j]}/stages-$i.txt || echo "FAILED ${NAMES[$j]} $i"
    echo "${NAMES[$j]} $(sha256sum /dev/shm/2874-volta-$TAG.o | cut -c1-16)" >> objects.txt
  done
done
rm -f /dev/shm/2874-volta-$TAG.o
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt
for name in "${NAMES[@]}"; do
  line="$name"
  for s in tier0 emit-setup branch-sizing encode unwind code-atoms publish-data object-build object-write lower total; do
    m=$(grep -h -P "^time-stage\t$s\t" $name/stages-*.txt | awk '{print $3}' | sort -n | awk '{v[NR]=$1} END {printf "%s (%s..%s)", v[int((NR+1)/2)], v[1], v[NR]}')
    line="$line $s=$m"
  done
  row=$(for f in $name/stages-*.txt; do awk -F'\t' '$1 == "time-stage" && ($2 == "tier0" || $2 == "emit-setup" || $2 == "branch-sizing" || $2 == "encode" || $2 == "unwind" || $2 == "code-atoms" || $2 == "publish-data" || $2 == "object-build" || $2 == "object-write") { s += $3 } END { print s }' $f; done | sort -n | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}')
  echo "$line row=$row"
done | tee table.txt
cut -d' ' -f2 objects.txt | sort -u
