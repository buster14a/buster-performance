#!/bin/bash
# The native (vector) row's Release builds with ASan and MSan, and the Tier 1 tests and pattern test on each.
set -u
cd /home/user/buster
git status --porcelain --untracked-files=no | grep -q . && { echo "tree not clean"; exit 1; }
echo "head $(git rev-parse HEAD)"
out=/home/user/rec2922/rows-native
mkdir -p $out
clang_path=$(command -v clang)
for san in address memory; do
    start=$(date +%s)
    env BUSTER_SANITIZER=$san nice -n 10 ./build.sh --config Release > $out/build-$san.log 2>&1
    echo "build $san: exit $? $(( $(date +%s) - start )) s"
    bin=$(env BUSTER_SANITIZER=$san ./build.sh print-output --config Release 2>/dev/null | tail -1)
    for t in "test-tier1-select" "test-tier1-emit" "test-tier1-pipeline --cross-check"; do
        start=$(date +%s)
        timeout 3600 $bin $t > $out/$san-${t%% *}.log 2>&1
        echo "$san $t: exit $? $(( $(date +%s) - start )) s: $(grep -E 'checks|failures' $out/$san-${t%% *}.log | tail -1 | cut -c1-120)"
    done
    mapfile -d '' -t flags < <(env BUSTER_SANITIZER=$san ./build.sh print-sanitizer-flags)
    clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing "${flags[@]}" tests/driver/tier1_patterns.c -o $out/patterns-$san && timeout 1800 $out/patterns-$san $bin "$clang_path" > $out/$san-patterns.log 2>&1
    echo "$san patterns: exit $? $(grep -E ': pass|fail' $out/$san-patterns.log | tr '\n' ' ' | cut -c1-160)"
done
echo done
