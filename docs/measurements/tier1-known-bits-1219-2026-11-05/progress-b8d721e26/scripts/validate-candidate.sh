#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 current-main integration' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
(cd fixed-v8 && "$HOME/buster-fast-bench/exclusive.sh" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --jobs 8) > fixed-v8-build.log 2>&1
for suite in test-tier1-select test-tier1-emit test-tier1-pipeline; do
    args=()
    [ "$suite" != test-tier1-pipeline ] || args=(--cross-check)
    set +e
    (cd fixed-v8 && "$HOME/buster-fast-bench/exclusive.sh" ./build/compiler "$suite" "${args[@]}") > "fixed-v8-$suite.log" 2>&1
    status=$?
    printf '%s %s\n' "$suite" "$status" >> fixed-v8-tests.status
    set -e
    test "$status" = 0
done
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/progs.sh "$PWD/fixed-v8/build/compiler" "$PWD/results/fixed-v8"
sha256sum fixed-v8/build/compiler results/fixed-v8/{st-t1,lua-t1} > fixed-v8-binaries.sha256
touch fixed-v8-tests.done
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 fixed-v8/build/compiler measure-tier1-programs --runs 11 --warmups 1 --clang /usr/bin/clang --sqlite "$PWD/corpus/sqlite" --speedtest "$PWD/inputs/st" --lua "$PWD/inputs/lua/lua-5.4.8/src" --scripts "$PWD/inputs/lua" --directory /dev/shm --keep > fixed-v8-runtime.log 2>&1
touch fixed-v8-runtime.done
