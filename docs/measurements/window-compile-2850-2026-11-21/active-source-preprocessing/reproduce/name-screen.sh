#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD;out=$root/results/active-source-name-screen;mkdir -p "$out"
source corpora.sh;eval "args=($sqlite_arguments)"
for r in 1 2 3;do
 case $r in
  1) arms=(eager names safe safe names eager);;
  2) arms=(safe eager names names eager safe);;
  3) arms=(names safe eager eager safe names);;
 esac
 ./lock.sh taskset -c 2 bash -c '
 set -e
 root=$1;out=$2;r=$3;shift 3;arms=("${@:1:6}");shift 6
 for i in {0..5};do
  arm=${arms[i]};case $arm in eager) bin=$root/results/active-source-profile/pinned;;names) bin=$root/results/active-direct-names/pilot;;safe) bin=$root/results/active-direct-safe/pilot;; esac
  for j in {1..5};do "$bin" "$@" >>"$out/$r-$i-$arm.tsv";done
 done
 ' _ "$root" "$out" "$r" "${arms[@]}" "${args[@]}" >"$out/$r.lock" 2>&1
done
