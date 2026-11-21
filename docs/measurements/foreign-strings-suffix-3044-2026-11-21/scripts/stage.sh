#!/bin/bash
# stage.sh RUNS SHAPE COUNT BIN...: merge-strings stage (ms) of 'link-foreign --merge-strings --time --lanes 1' over the
# kept benchmark objects of SHAPE/COUNT (SHAPE br: build_regression.o's link line), binaries interleaved per run;
# prints min/median/max per binary.
S=/tmp/claude-0/-home-user/17ca334c-b389-40bd-9a1c-a7a69684778b/scratchpad
J=$S/r3044/judge
runs=$1; shape=$2; count=$3; shift 3
bins=("$@")
for b in "${!bins[@]}"; do : > $J/st-$b.txt; done
if [ "$shape" != br ]; then
  dir=$(ls -d $S/r3044/bench/$shape/*/ | head -1)
  objs=$(ls $dir/strings_${shape}_${count}_u*.o | sort -V)
fi
for i in $(seq 1 $runs); do
  for b in "${!bins[@]}"; do
    if [ "$shape" = br ]; then
      bash $S/s3044/brl/lf.sh "${bins[$b]}" $J/out-$b 2>&1 | awk '/merge-strings/ {print $2}' >> $J/st-$b.txt
    else
      "${bins[$b]}" link-foreign --merge-strings --time --lanes 1 -o $J/out-$b $objs 2>&1 | awk '/merge-strings/ {print $2}' >> $J/st-$b.txt
    fi
  done
done
for b in "${!bins[@]}"; do
  sort -g $J/st-$b.txt | awk -v b="$(basename ${bins[$b]})" -v s=$shape -v c=$count '{v[NR]=$1} END {printf "%s %s %s: n %d min %.3f median %.3f max %.3f ms\n", s, c, b, NR, v[1], v[int((NR+1)/2)], v[NR]}'
done
