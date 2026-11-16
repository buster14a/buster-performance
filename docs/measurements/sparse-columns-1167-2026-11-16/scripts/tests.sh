#!/bin/bash
# tests.sh TREE LOG: the reader's and the checker's tests on TREE's build (from the tree's root, as CI's correctness
# list runs them), each command in one hold of the lock with a timeout of its own; a line a command in LOG: its status
# and seconds, its output in LOG.d/N.txt.
set -u
cd "$(dirname "$0")"
here=$PWD
tree=$1
log=$2
mkdir -p "$log.d"
: > "$log"
commands=()
for k in 1 2 3 4 5 6 7 8; do commands+=("./build/compiler test-checker --seed 133 --part $k/8"); done
commands+=("./build/compiler test-checker-deferred" "./build/compiler test-check-units")
for k in 1 2 3 4 5 6 7 8; do commands+=("./build/compiler test-checker-driver --executable ./build/compiler --part $k/8 --in-process"); done
n=0
for c in "${commands[@]}"; do
    start=$(date +%s)
    (cd "$here/$tree" && timeout -k 10 540 "$here/lock.sh" bash -c "cd '$here/$tree' && $c") > "$log.d/$n.txt" 2>&1
    status=$?
    echo "$status $(( $(date +%s) - start ))s $c" >> "$log"
    n=$((n + 1))
done
