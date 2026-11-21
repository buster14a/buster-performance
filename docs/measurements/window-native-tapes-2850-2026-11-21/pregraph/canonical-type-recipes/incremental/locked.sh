#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-linked-type-views
shared=../2850-declaration-starts
for f in corpora.sh build-label.sh lock.sh; do cp "$shared/$f" .; done
ln -sfn "$shared/src" src
ln -sfn ../2850-codex-step2/inputs inputs
export BUSTER_HOST_ARCH=znver5
./build-label.sh probe 84a7d3d76891d6c393497e62e6aff38f2b162fc2 experiment.patch
source ./corpora.sh
mkdir -p readings
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
export NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1 NODE_CROSS_CHUNK=b NODE_CROSS_TYPE_VIEW=1 NODE_SOURCE_STRINGS=1
for round in {1..7}; do
 for g in sqlite lua musl; do
  v=${g}_arguments;eval "args=(${!v})"
  if [[ $((round%2)) == 1 ]];then order=(copy links links copy);else order=(links copy copy links);fi
  flock -x 9
  for i in 0 1 2 3; do
   mode=${order[$i]}; p=readings/$g-$round-$i-$mode
   opts=(env -u NODE_CROSS_INCREMENTAL -u NODE_CROSS_TYPE_WIDE)
   case $mode in
    copy) opts+=(NODE_CROSS_TYPE_WIDE=1);;
    links) opts+=(NODE_CROSS_INCREMENTAL=1);;
   esac
   ./lock.sh taskset -c 2 "${opts[@]}" ./results/probe/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" >"$p.out" 2>"$p.err"
   grep -E '^(cross-cost |source-rows |cross-keys |probe-full different-values|node-proof call-roots|node-proof stream roots)' "$p.err" >"$p.timings"
   grep '^probe-native ' "$p.out" >"$p.receipt"
   gzip -f "$p.out" "$p.err"
  done
  flock -u 9
 done
done
date -u +%FT%TZ >readings/all.done
