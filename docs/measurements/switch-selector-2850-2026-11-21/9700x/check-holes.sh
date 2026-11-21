#!/bin/bash
set -eu
cd "$HOME/buster-fast-bench/2850-switch-3217-integrated"
mkdir -p holes
for label in before after; do
 for mode in default wall everything; do
  opts=()
  [[ $mode == wall ]] && opts=(-Wall -Wextra)
  [[ $mode == everything ]] && opts=(-Weverything -Wno-c++-compat)
  st=0
  results/$label/compiler measure-node-machine --shadow --window-rows --passes 0 --list 8 "${opts[@]}" trees/after/tests/checker/sources/pointer-constant-equality.c > "holes/$label-$mode.log" 2>&1 || st=$?
  echo "$label $mode $st" >> holes/status
 done
done
