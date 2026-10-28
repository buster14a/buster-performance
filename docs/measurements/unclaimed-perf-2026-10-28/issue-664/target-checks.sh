#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/unclaimed-perf-20261028"
mkdir -p results/664-native
for spec in popcount:4000:0 popcount:8000:0 overflow:2000:1 overflow:4000:1 expect:8000:2; do
    IFS=: read -r kind count op <<< "$spec"
    for role in base issue-664; do
        taskset -c 2 "./$role/build/compiler" --lanes 1 -c "evidence-664/$kind-$count.c" -o "results/664-native/$kind-$count.$role.o"
    done
    cmp "results/664-native/$kind-$count.base.o" "results/664-native/$kind-$count.issue-664.o"
    clang -O2 -DCOUNT="$count" -DOP="$op" evidence-664/run_builtin.c "results/664-native/$kind-$count.issue-664.o" -o "results/664-native/$kind-$count.native"
    taskset -c 2 "results/664-native/$kind-$count.native"
done
sha256sum results/664-native/*.o
./issue-664/build/compiler test-tier0 --seed 664 --count 64 --cross-check --cross-count 12
