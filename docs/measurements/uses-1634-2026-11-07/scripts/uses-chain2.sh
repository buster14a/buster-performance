#!/bin/bash
# #1634's A/B, second candidate (the tzcnt walk): rebuild cand and its placements, then the measurement steps. The
# first candidate's partial benchmark-ir round is kept as results/ir-compress.log.
set -u
D=$HOME/buster-fast-bench/uses-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-uses EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1634 EXCLUSIVE_TITLE="#1634 use-list builder A/B"
LOCK=$HOME/buster-fast-bench/exclusive.sh
test -f results/ir-compress.log || mv results/ir.log results/ir-compress.log
mv results/shifts-cand.log results/shifts-cand-compress.log 2> /dev/null
./uses-ab.sh build
(cd cand && BUSTER_DEBUG_INFO=0 "$LOCK" ./build.sh shifts "$D/shifts-cand" main_unit_backend.c 256 1024) > results/shifts-cand.log 2>&1
tail -1 results/shifts-cand.log
./uses-ab.sh ir source tier1
