#!/bin/bash
# #2630 step 2: the correctness inventory's blocks that the cloud run of the whole inventory (a 4-CPU container, every
# other block passed by the same hybrid) couldn't judge, run here by the self-built Develop executable in its own tree:
# GNU as's relaxation in test-assembler and test-branch-sizing (binutils 2.42 there, 2.47 here), streaming with perf,
# SQLite's Tcl testfixture and the disassembler against GNU tools; and the ownership check, which the cloud run failed
# before its fix. One hold.
set -uo pipefail
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
L=$d/scripts/lock.sh
out=$d/results/inventory
mkdir -p "$out"
export BUSTER_SELF_BUILT=tests BUSTER_ORACLE_CACHE=use
export BUSTER_CI_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/buster/ci"
export BUSTER_CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
cd "$d/src" || exit 2
awk -v RE="unity fixture ownership|scalar and AVX-512 assembly frontends|^== Test branch sizing|streaming the output|Tcl suite|disassembler against GNU tools" \
    '/^== / { keep = ($0 ~ RE) } keep { print }' tools/ci/correctness.tests > "$out/blocks.tests"
grep '^== ' "$out/blocks.tests" > "$out/blocks.txt"
"$L" bash -c '
    set -e
    ./build.sh > "$1/prepare.log" 2>&1
    [ -d build/sqlite ] || bash tools/ci/fetch-sqlite.sh build/sqlite >> "$1/prepare.log" 2>&1
    compiler=build/cmake/native/Develop/compiler
    sha256sum "$compiler" > "$1/compiler.sha256"
    ls build/cmake/native/Develop/self >> "$1/compiler.sha256"
    taskset -c 0-7 "$compiler" parallel --jobs 8 --timeout 600 < "$1/blocks.tests" > "$1/blocks.log" 2>&1
    echo "status $?" >> "$1/blocks.log"' blocks "$out"
tail -1 "$out/blocks.log"
grep '^== ' "$out/blocks.log"
echo inventory-done
