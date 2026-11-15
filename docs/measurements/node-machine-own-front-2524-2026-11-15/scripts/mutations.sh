#!/bin/bash
# run.sh COMPILER "MUTATIONS" [corpora]: the front's differences and made expressions by mutation, on the fixture and the corpora.
compiler=$1; mutations=$2; corpora=${3:-"fixture sqlite lua musl"}
fx=${FIXTURE:-/tmp/claude-0/-home-user/d2e261bc-e319-52e6-9f39-10bb9f312ad8/scratchpad/fx/shadow.c}
for m in $mutations; do
  line="mutation $m:"
  for c in $corpora; do
    if [ $c = fixture ] || [ $c = boundaries ] || [ $c = full ]; then
      f=$fx; [ $c = fixture ] || f=$(dirname $fx)/$c.c
      out=$(BUSTER_FRONT_MUTATION=$m $compiler measure-node-machine --shadow --front --passes 0 -nostdinc -Wall -Wextra -Wshift-sign-overflow -Wassign-enum $f 2>&1)
    else
      out=$(BUSTER_FRONT_MUTATION=$m ~/.cache/claude-2524s/shapes-local.sh $compiler $c --front --passes 0 2>&1)
    fi
    d=$(echo "$out" | sed -n 's/.*node-shadow: front after-the-walk.* differences=\([0-9]*\) resets=\([0-9]*\) waiting-at-the-end=\([0-9]*\).*/\1 waiting=\3/p')
    e=$(echo "$out" | sed -n 's/.*node-shadow: front taken-expressions=\([0-9]*\) .*/\1/p')
    line="$line $c differences=${d:-?} made=${e:-?};"
  done
  echo "$line"
done
