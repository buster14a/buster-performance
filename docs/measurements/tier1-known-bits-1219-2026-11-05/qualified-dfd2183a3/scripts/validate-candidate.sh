#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 shared signed parameter storage' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
(cd parameters-v16 && "$HOME/buster-fast-bench/exclusive.sh" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --jobs 8) > parameters-v16-build.log 2>&1
for suite in test-tier1-select test-tier1-emit test-tier1-pipeline; do
    args=()
    [ "$suite" != test-tier1-pipeline ] || args=(--cross-check)
    set +e
    (cd parameters-v16 && "$HOME/buster-fast-bench/exclusive.sh" ./build/compiler "$suite" "${args[@]}") > "parameters-v16-$suite.log" 2>&1
    status=$?
    printf '%s %s\n' "$suite" "$status" >> parameters-v16-tests.status
    set -e
    test "$status" = 0
done
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/progs.sh "$PWD/parameters-v16/build/compiler" "$PWD/results/parameters-v16"
sha256sum parameters-v16/build/compiler results/parameters-v16/{st-t1,lua-t1} > parameters-v16-binaries.sha256
touch parameters-v16-tests.done
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 parameters-v16/build/compiler measure-tier1-programs --runs 11 --warmups 1 --clang /usr/bin/clang --sqlite "$PWD/corpus/sqlite" --speedtest "$PWD/inputs/st" --lua "$PWD/inputs/lua/lua-5.4.8/src" --scripts "$PWD/inputs/lua" --directory /dev/shm --keep > parameters-v16-runtime.log 2>&1
touch parameters-v16-runtime.done
