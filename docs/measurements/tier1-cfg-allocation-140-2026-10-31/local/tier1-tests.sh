#!/usr/bin/env bash
# tier1-tests.sh TREE LOGS: the Tier 1 group of the correctness inventory, each command's output in LOGS.
set -u
tree=$1
logs=$2
mkdir -p "$logs"
cd "$tree" || exit 1
unset CPATH C_INCLUDE_PATH
status=0
run()
{
    local name=$1
    shift
    "$@" > "$logs/$name.log" 2>&1
    local s=$?
    echo "$name exit $s: $(tail -1 "$logs/$name.log")"
    [ $s -eq 0 ] || status=1
}
run select ./build/compiler test-tier1-select --manifest
run liveness ./build/compiler test-tier1-liveness
run emit ./build/compiler test-tier1-emit
run pipeline ./build/compiler test-tier1-pipeline --cross-check
run model ./build/compiler test-tier1-model
run schedule ./build/compiler test-tier1-schedule
run frame ./build/compiler test-tier1-frame
run frame-execution ./build/compiler test-tier1-frame-execution
run allocation ./build/compiler test-tier1-allocation
run cfg ./build/compiler test-tier1-cfg
run dataflow ./build/compiler test-dataflow
run dominators ./build/compiler test-dominators
exit $status
