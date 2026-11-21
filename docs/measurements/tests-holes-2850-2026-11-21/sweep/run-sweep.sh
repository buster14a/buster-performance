#!/bin/bash
# run-sweep.sh TAG COMPILER: the regression programs and the inline ones under three warning sets.
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
tag=$1; compiler=$2
mkdir -p $S/holes/$tag
cd /home/user/buster-values
for set in default wall everything; do
  case $set in
    default) options="" ;;
    wall) options="-Wall -Wextra" ;;
    everything) options="-Weverything -Wno-c++-compat" ;;
  esac
  for pile in tests inline; do
    python3 /home/user/keep/holes/sweep.py $compiler $S/holes/$tag/$pile-$set.tsv 4 $options < $S/holes/$pile.list > $S/holes/$tag/$pile-$set.log 2>&1
    echo "$pile $set: $(cat $S/holes/$tag/$pile-$set.log | tail -1)"
  done
done
echo "sweep exit 0"
