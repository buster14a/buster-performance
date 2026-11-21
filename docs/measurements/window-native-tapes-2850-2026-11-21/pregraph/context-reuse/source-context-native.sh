#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-source-context-reuse
shared=../2850-declaration-starts
for f in corpora.sh build-label.sh lock.sh; do cp "$shared/$f" .; done
ln -sfn "$shared/src" src
ln -sfn ../2850-codex-step2/inputs inputs
export BUSTER_HOST_ARCH=znver5
./build-label.sh probe 84a7d3d76891d6c393497e62e6aff38f2b162fc2 experiment.patch
source ./corpora.sh
mkdir -p readings
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
export NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1
for round in {1..7}; do
  for group in sqlite lua musl; do
    v=${group}_arguments
    eval "args=(${!v})"
    order=(off on on off)
    if ((round % 2 == 0)); then order=(on off off on); fi
    flock -x 9
    for i in 0 1 2 3; do
      tag=${order[$i]}
      pre="readings/$group-$round-$i-$tag"
      policy=(env -u NODE_SOURCE_REUSE_C)
      if [[ $tag == on ]]; then policy=(env NODE_SOURCE_REUSE_C=1);fi
      ./lock.sh taskset -c 2 "${policy[@]}" ./results/probe/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" >"$pre.out" 2>"$pre.err"
      rg '^(source-T |source-cost |source-rows )' "$pre.err" > "$pre.timings" || grep -E '^(source-T |source-cost |source-rows )' "$pre.err" >"$pre.timings"
      grep -E '^probe-native|^node-shadow: reader-time C and X compared=' "$pre.out" > "$pre.receipt"
      gzip -f "$pre.err" "$pre.out"
    done
    flock -u 9
  done
done
date -u +%FT%TZ > readings/all.done
