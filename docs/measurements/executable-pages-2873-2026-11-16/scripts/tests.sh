#!/bin/bash
# tests.sh TREE LOG: the tests of what the change touches and the compile path's on TREE's build (from the tree's root,
# as CI's correctness list runs them), each command in one hold of the lock with a timeout of its own; a line a command
# in LOG: its status and seconds, its output in LOG.d/N.txt. The oracle clang is CI's (the build's toolchain, 23.1.4),
# first on PATH; the host's own is another release, which the driver's tests refuse as a reference.
set -u
cd "$(dirname "$0")"
here=$PWD
tree=$1
log=$2
mkdir -p "$log.d"
: > "$log"
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang-23 | head -1)")
export PATH="$clang_bin:$PATH"
commands=("./build/compiler test-profile" "./build/compiler test-lanes" "./build/compiler test-check-lanes" "./build/compiler test-baked-tables" "./build/compiler test-call-graph"
    "./build.sh check-call-graph --config Release" "./build/compiler test-check-units" "./build/compiler test-checker-deferred")
for k in 1 2 3 4 5 6 7 8; do commands+=("./build/compiler test-checker --seed 133 --part $k/8"); done
for k in 1 2 3 4 5 6 7 8; do commands+=("./build/compiler test-checker-driver --executable ./build/compiler --part $k/8 --in-process"); done
n=0
for c in "${commands[@]}"; do
    start=$(date +%s)
    (cd "$here/$tree" && timeout -k 10 900 "$here/lock.sh" bash -c "cd '$here/$tree' && $c") > "$log.d/$n.txt" 2>&1
    status=$?
    echo "$status $(( $(date +%s) - start ))s $c" >> "$log"
    n=$((n + 1))
done
echo done >> "$log"
