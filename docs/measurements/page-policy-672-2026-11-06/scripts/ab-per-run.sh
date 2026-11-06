#!/bin/bash
# usage: ab-per-run.sh OUT A_LABEL A B_LABEL B -- 7 rounds; in each, the counts 1, 8, 2, 4 in turn, and for each count
# both builds, alternating which goes first; one lock hold per run (one-run.sh under exclusive.sh). Not under the lock
# itself: it waits for the lock before each run, as the host's README asks.
cd ~/buster-fast-bench/672-claude
out=$1; la=$2; a=$3; lb=$4; b=$5
mkdir -p $out
sha256sum $a $b /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c > $out/identities.sha256
for r in 1 2 3 4 5 6 7; do
  for n in 1 8 2 4; do
    if (( (r + n) % 2 == 0 )); then order="$la:$a $lb:$b"; else order="$lb:$b $la:$a"; fi
    for x in $order; do
      ./lock.sh ./one-run.sh $out ${x%%:*} ${x#*:} $n $r
    done
  done
done
echo done >> $out/runs.txt
