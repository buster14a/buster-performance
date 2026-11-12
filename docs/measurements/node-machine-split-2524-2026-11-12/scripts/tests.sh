#!/bin/bash
# tests.sh TREE: TREE's test-checker, ./build.sh check-call-graph, test-baked-tables and the build regression's ownership
# check, each in its own hold of the lock, each one's output and status in tests-TREE-NAME.log.
set -u
cd "$(dirname "$0")"
tree=$1
run()
{
    local name=$1
    shift
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd '$tree' && git log --oneline -1 && $*" > "tests-$tree-$name.log" 2>&1
    echo "status $?" >> "tests-$tree-$name.log"
}
run test-checker "taskset -c 2 ./build/compiler test-checker"
run check-call-graph "./build.sh check-call-graph"
run test-baked-tables "taskset -c 2 ./build/compiler test-baked-tables"
run ownership "cc -std=c17 -O2 -Wall -Wextra -Werror -o build/buster-build-regression tools/ci/build_regression.c && ./build/buster-build-regression --ownership-only \"\$(./build.sh print-output --config Release)\""
date -u +%FT%TZ > "tests-$tree.done"
