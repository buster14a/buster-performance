#!/bin/bash
# run_types.sh COMPILER "MUTATIONS" [targets]: T at reader time under each fault, on the fixtures (whole and lean) and the
# corpora: the differences each shows.
compiler=$1; mutations=$2; targets=${3:-"fixture fixture-lean boundaries boundaries-lean full sqlite lua"}
S=/tmp/claude-0/-home-user/d2e261bc-e319-52e6-9f39-10bb9f312ad8/scratchpad
for m in $mutations; do
  line="mutation $m:"
  for t in $targets; do
    case $t in
      fixture|boundaries|full) f=$S/fx/$t.c; [ $t = fixture ] && f=$S/fx/shadow.c
        out=$(BUSTER_TYPES_MUTATION=$m $compiler measure-node-machine --shadow --front-types --passes 0 -nostdinc -Wall -Wextra -Wshift-sign-overflow -Wassign-enum $f 2>&1) ;;
      fixture-lean|boundaries-lean) b=${t%-lean}; f=$S/fx/$b.c; [ $b = fixture ] && f=$S/fx/shadow.c
        out=$(BUSTER_TYPES_MUTATION=$m $compiler measure-node-machine --shadow --front-lean --front-types --passes 0 -nostdinc -Wall -Wextra -Wshift-sign-overflow -Wassign-enum $f 2>&1) ;;
      *) out=$(BUSTER_TYPES_MUTATION=$m ~/.cache/claude-2524s/shapes-local.sh $compiler $t --front-types --passes 0 2>&1) ;;
    esac
    d=$(echo "$out" | sed -n 's/.*reader-time T lowered=.* compared=\([0-9]*\) .*differences=\([0-9]*\) (range \([0-9]*\), refusal \([0-9]*\)).*not-run=\([0-9]*\)$/c\1 d\2 r\3 f\4 u\5/p')
    o=$(echo "$out" | sed -n 's/.*reader-time T objects=[0-9]* differences=\([0-9]*\) library-calls=\([0-9]*\) differences=\([0-9]*\)/o\1 l\3/p')
    line="$line $t ${d:-?} ${o:-?};"
  done
  echo "$line"
done
