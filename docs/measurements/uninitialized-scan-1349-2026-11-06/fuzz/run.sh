#!/bin/bash
# run.sh FIRST LAST: generate seeds FIRST..LAST and compare main's and the branch's -Wall -fsyntax-only, vector and --scalar.
A=/home/user/bench/compiler-1349-main; B=/home/user/bench/compiler-1349-branch
same=0; differ=0; warned=0
for s in $(seq $1 $2); do
  python3 gen.py $s > f$s.c
  for m in "" --scalar; do
    a=$($A -std=gnu17 -fsyntax-only -Wall f$s.c $m 2>&1); ea=$?
    b=$($B -std=gnu17 -fsyntax-only -Wall f$s.c $m 2>&1); eb=$?
    if [ "$a" == "$b" ] && [ $ea == $eb ]; then same=$((same+1)); else differ=$((differ+1)); echo "DIFF seed $s mode '$m'"; fi
    warned=$((warned + $(printf '%s\n' "$a" | grep -c "within its own initialization")))
  done
  rm -f f$s.c
done
echo "runs $((same+differ)) same $same differ $differ self-init-warnings $warned"
