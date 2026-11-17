#!/bin/bash
# The x86-64 row's Release builds (plain, address, memory) and the Tier 1 tests on each.
set -u
cd /home/user/buster
git status --porcelain --untracked-files=no | grep -q . && { echo "tree not clean"; exit 1; }
echo "head $(git rev-parse HEAD)"
out=/home/user/rec2922/rows-final
mkdir -p $out
clang_path=$(command -v clang)
for san in none address memory; do
    if [ $san = none ]; then env_s=""; else env_s="BUSTER_SANITIZER=$san"; fi
    start=$(date +%s)
    env BUSTER_HOST_ARCH=x86-64 $env_s nice -n 10 ./build.sh --config Release > $out/build-$san.log 2>&1
    echo "build $san: exit $? $(( $(date +%s) - start )) s"
    bin=$(env BUSTER_HOST_ARCH=x86-64 $env_s ./build.sh print-output --config Release 2>/dev/null | tail -1)
    cp "$bin" $out/compiler-$san 2>/dev/null || cp build/compiler $out/compiler-$san
    for t in "test-tier1-select" "test-tier1-emit" "test-tier1-pipeline --cross-check"; do
        start=$(date +%s)
        timeout 3600 $out/compiler-$san $t > $out/$san-${t%% *}.log 2>&1
        echo "$san $t: exit $? $(( $(date +%s) - start )) s: $(grep -E 'checks|failures' $out/$san-${t%% *}.log | tail -1 | cut -c1-120)"
    done
    mapfile -d '' -t flags < <(env BUSTER_HOST_ARCH=x86-64 $env_s ./build.sh print-sanitizer-flags)
    clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing "${flags[@]}" tests/driver/tier1_patterns.c -o $out/patterns-$san && timeout 1800 $out/patterns-$san $out/compiler-$san "$clang_path" > $out/$san-patterns.log 2>&1
    echo "$san patterns: exit $? $(grep -E ': pass|fail' $out/$san-patterns.log | tr '\n' ' ' | cut -c1-200)"
done
echo done
