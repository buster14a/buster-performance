#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
out=$PWD/results/constfcc/fixture
mkdir -p "$out"
src=$PWD/trees/constfcc/tests/checker/node-window-constants.c
for which in contiguous remapped;do
 define=(); [[ $which != remapped ]] || define=(-DWINDOW_REMAPPED_SOURCE)
 for instrument in ordinary staged;do
  instr=(); [[ $instrument != staged ]] || instr=(--time-stages)
  for mode in parent plain constants;do
   exe=$PWD/results/constfcc/compiler; option=()
   [[ $mode != parent ]] || exe=$PWD/results/refaff3252/compiler
   [[ $mode != constants ]] || option=(--node-window-constants)
   stem=$out/$which-$instrument-$mode
   "$exe" "${instr[@]}" "${option[@]}" --lanes 1 -g -c "${define[@]}" "$src" -o "$stem.o" >"$stem.stdout" 2>"$stem.stderr"
   cmp "$out/$which-ordinary-parent.o" "$stem.o"
   cmp "$out/$which-ordinary-parent.stdout" "$stem.stdout"
   if [[ $instrument == ordinary ]];then cmp "$out/$which-ordinary-parent.stderr" "$stem.stderr";fi
  done
 done
 grep -E '^constant-window: roots=4 removed=10 graph-nodes=[0-9]+$' "$out/$which-staged-constants.stderr"
done
(cd "$out" && sha256sum *.o >object-sha256.txt)
echo COMPLETE
