#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "$1")
export BUSTER_PARALLEL_CPUS=${CORES:-1}
"$compiler" test-interpreter
"$compiler" test-interpreter-native
"$compiler" test-interpreter-link
"$compiler" test-ssa-source --typed tests/interpreter/source.c
"$compiler" test-ssa-source --typed --tier1 -DBUSTER_INTERPRETER_LARGE_WORDS=64 tests/interpreter/source.c
"$compiler" test-ssa-source --typed --tier1 --self-test
