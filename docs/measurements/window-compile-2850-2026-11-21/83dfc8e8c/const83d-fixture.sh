#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
out=$PWD/results/const83d/fixture
mkdir -p "$out"
exe=$PWD/results/const83d/compiler
src=$PWD/trees/const83d/tests/checker/node-window-constants.c
args=(--time-stages --lanes 1 -g -c)
for which in contiguous remapped;do
 define=()
 [[ $which != remapped ]] || define=(-DWINDOW_REMAPPED_SOURCE)
 for mode in plain constants;do
  option=()
  [[ $mode != constants ]] || option=(--node-window-constants)
  "$exe" "${option[@]}" "${args[@]}" "${define[@]}" "$src" -o "$out/$which-$mode.o" >"$out/$which-$mode.stdout" 2>"$out/$which-$mode.stderr"
 done
 cmp "$out/$which-plain.o" "$out/$which-constants.o"
 cmp "$out/$which-plain.stdout" "$out/$which-constants.stdout"
 grep -E '^constant-window: roots=4 removed=10 graph-nodes=[0-9]+$' "$out/$which-constants.stderr"
done
(cd "$out" && sha256sum *.o && sha256sum *.o >object-sha256.txt)
echo COMPLETE
