#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD;out=$PWD/results/active-source-final;mkdir -p "$out"
source corpora.sh;eval "args=($sqlite_arguments)"
./lock.sh taskset -c 2 bash -c '
set -e
root=$1;out=$2
export PATH="$(bash trees/factsmain0e1d/tools/ci/session-toolchain.sh stage):$PATH"
src=$root/trees/livegroupfixed/src
clang -O3 -gline-tables-only -fno-omit-frame-pointer -std=gnu17 -fwrapv -funsigned-char -march=native -I"$src" -I"$src/buster/compiler" active-source-fresh.c -o "$out/cursor"
sha256sum "$out/cursor" results/active-direct-directives/pilot results/active-source-profile/pinned
' _ "$root" "$out" >"$out/build.log" 2>&1
for round in 1 2 3;do
 case $round in
  1) arms=(eager cursor direct direct cursor eager);;
  2) arms=(direct eager cursor cursor eager direct);;
  3) arms=(cursor direct eager eager direct cursor);;
 esac
 ./lock.sh taskset -c 2 bash -c '
  set -e
  root=$1; out=$2; round=$3; shift 3
  arms=("${@:1:6}"); shift 6
  for i in {0..5};do
   arm=${arms[i]}
   case $arm in eager) exe=$root/results/active-source-profile/pinned;; cursor) exe=$out/cursor;; direct) exe=$root/results/active-direct-directives/pilot;;esac
   for n in {1..5};do "$exe" "$@" >>"$out/$round-$i-$arm.tsv";done
   "$root/results/baked177/compiler" time-runs --runs 3 --warmups 1 --executable "$exe" --list "$@" >"$out/$round-$i-$arm.wall" 2>"$out/$round-$i-$arm.stderr"
  done
 ' _ "$root" "$out" "$round" "${arms[@]}" "${args[@]}" >"$out/$round.lock" 2>&1
done
