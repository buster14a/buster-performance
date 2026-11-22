#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD;out=$root/results/active-paired-profile;mkdir -p "$out"
source corpora.sh;eval "args=($sqlite_arguments)"
./lock.sh taskset -c 2 bash -c '
 set -e
 root=$1;out=$2;shift 2
 for arm in eager direct;do
  case $arm in eager) exe=$root/results/active-source-profile/pinned;;direct) exe=$root/results/active-direct-directives/pilot;;esac
  perf record -e cycles:u -c 150003 -g --call-graph fp -o "$out/$arm.perf" -- bash -c '\''exe=$1;shift;for i in {1..35};do "$exe" "$@" || exit;done'\'' _ "$exe" "$@" >"$out/$arm.runs" 2>"$out/$arm.err"
  perf report --stdio --no-children -g none -n --sort comm,symbol,srcline --percent-limit 0 -i "$out/$arm.perf" >"$out/$arm.lines"
  perf report --stdio --no-children -g none -n --sort comm,symbol --percent-limit 0 -i "$out/$arm.perf" >"$out/$arm.flat"
  sha256sum "$exe" >>"$out/compilers.txt"
 done
' _ "$root" "$out" "${args[@]}" >"$out/lease.log" 2>&1
