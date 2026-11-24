#!/bin/bash
# run-list.sh LIST LOG [CPUS]: one locked parallel run of a correctness list with this tree's build/compiler.
. ~/buster-fast-bench/2924-asm-pp-claude/env.sh
list=$1; log=$2; cpus=${3:-8}
cd "$W/src"
$EX timeout -k 5 540 env BUSTER_COMPILER=$PWD/build/compiler taskset -c 0-$((cpus - 1)) ./build/compiler parallel --jobs "$cpus" --timeout 500 < "$list" > "$log" 2>&1
echo "exit=$?" >> "$log"
