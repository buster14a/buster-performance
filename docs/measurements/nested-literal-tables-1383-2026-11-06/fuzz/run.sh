#!/bin/bash
# usage: run.sh first last — differential -c of generated tables, main vs branch: exit, object, diagnostics
cd /home/user/fuzz/rows
d=0; ok=0; n=0
for s in $(seq $1 $2); do
  python3 gen.py $s t.c
  /home/user/bench/compiler-main -c t.c -o m.o > m.err 2>&1; e1=$?
  /home/user/bench/compiler-rows -c t.c -o b.o > b.err 2>&1; e2=$?
  n=$((n+1))
  if [ $e1 -ne $e2 ]; then echo "seed $s exit $e1 $e2"; cp t.c fail-$s.c; d=$((d+1));
  elif [ $e1 -eq 0 ]; then ok=$((ok+1)); cmp -s m.o b.o || { echo "seed $s object"; cp t.c fail-$s.c; d=$((d+1)); }; cmp -s m.err b.err || { echo "seed $s warnings"; cp t.c fail-$s.c; d=$((d+1)); };
  else cmp -s m.err b.err || { echo "seed $s diagnostics"; cp t.c fail-$s.c; d=$((d+1)); }; fi
  rm -f m.o b.o
done
echo "files $n, compiled $ok, differ $d"
