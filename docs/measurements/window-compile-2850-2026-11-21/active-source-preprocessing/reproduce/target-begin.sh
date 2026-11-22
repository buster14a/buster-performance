#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD
out=$PWD/results/active-source-profile
mkdir -p "$out"
src=$PWD/trees/factsmain0e1d/src
source corpora.sh
eval "args=($sqlite_arguments)"
./lock.sh bash -c '
set -e
source_dir=$1; result_dir=$2; driver=$3
cc=$(command -v clang)
"$cc" --version | head -1
"$cc" -O3 -gline-tables-only -fno-omit-frame-pointer -std=gnu17 -fwrapv -funsigned-char -march=native -I"$source_dir" -I"$source_dir/buster/compiler" "$driver" -o "$result_dir/fresh"
' _ "$src" "$out" "$PWD/active-source-fresh.c" >"$out/build.log" 2>&1
for r in 1 2 3;do
 ./lock.sh taskset -c 2 bash -c '
 set -e
 out=$1; round=$2; shift 2
 cd "$out"
 for type in ordinary history timed ordinary timed history ordinary; do
  case $type in
   ordinary) ./fresh "$@" >>"$round-ordinary.tsv";;
   history) PP_RECORD_HISTORY=1 ./fresh "$@" >>"$round-history.tsv";;
   timed) PP_STAGE_TIMING=1 ./fresh "$@" >>"$round-timed.tsv";;
  esac
 done
 ' _ "$out" "$r" "${args[@]}" >"$out/$r.lock" 2>&1
done
./lock.sh taskset -c 2 bash -c '
 set -e
 out=$1;shift
 cd "$out"
 perf record -e cycles:u -c 150003 -g --call-graph fp -o pp.perf -- bash -c '\''for i in {1..35}; do ./fresh "$@" || exit; done'\'' _ "$@" >profile.out 2>profile.err
 perf report --stdio --no-children --percent-limit=0 -i pp.perf >flat.txt
 perf report --stdio --children --percent-limit=0.3 -i pp.perf >inclusive.txt
 PP_DUMP_FORM=1 ./fresh "$@" >census.out 2>census.err
 sha256sum fresh primary.raw output.rows >hashes.txt
' _ "$out" "${args[@]}" >"$out/profile.lock" 2>&1
