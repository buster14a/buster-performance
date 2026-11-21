#!/usr/bin/env bash
set -euo pipefail
ulimit -c 0
cd "$(dirname "$0")/../program-control-markers-prod"
if [[ -n ${BUSTER_CLANG_BIN:-} ]]; then export PATH="$BUSTER_CLANG_BIN:$PATH"; fi
suite=$1
mkdir -p "../program-control-markers-prod-qa/$suite"
if [[ $suite = checker ]]; then
    seq 1 8 | xargs -P2 -I{} bash -c './build/compiler test-checker --seed 133 --part "$1/8" >"../program-control-markers-prod-qa/checker/$1.log" 2>&1' _ {}
else
    seq 1 8 | xargs -P2 -I{} bash -c './build/compiler test-checker-driver --in-process --executable "$PWD/build/compiler" --part "$1/8" >"../program-control-markers-prod-qa/driver/$1.log" 2>&1' _ {}
fi
