#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD;out=$root/results/active-source-batches-screen;mkdir -p "$out"
source corpora.sh;eval "args=($sqlite_arguments)"
for r in 1 2 3;do
 case $r in
  1) arms=(eager spans batches batches spans eager);;
  2) arms=(batches eager spans spans eager batches);;
  3) arms=(spans batches eager eager batches spans);;
 esac
 ./lock.sh taskset -c 2 bash -c '
 set -e
 root=$1;out=$2;r=$3;shift 3;arms=("${@:1:6}");shift 6
 for i in {0..5};do
  arm=${arms[i]};case $arm in eager) bin=$root/results/active-source-profile/pinned;;spans) bin=$root/results/active-direct-spans/pilot;;batches) bin=$root/results/active-direct-batches/pilot;; esac
  for j in {1..5};do "$bin" "$@" >>"$out/$r-$i-$arm.tsv";done
 done
 ' _ "$root" "$out" "$r" "${arms[@]}" "${args[@]}" >"$out/$r.lock" 2>&1
done
