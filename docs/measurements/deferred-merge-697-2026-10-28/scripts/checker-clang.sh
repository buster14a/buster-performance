#!/bin/bash
# test-checker's four fpclassify failures on head-c with the host's clang 23.1.1: the same command on head-a (main with
# the merge's parts timed, which test-checker doesn't run), and on head-c with the CI's clang 23.1.4 on PATH. One hold each.
D=~/buster-fast-bench/697-cloud
cd "$D" || exit 1
run_in()
{
    local dir="$1" log="$2" title="$3"
    shift 3
    {
        echo "== $(date -u +%FT%TZ) $dir $*"
        (cd "$D/$dir" && EXCLUSIVE_OWNER=claude-697-cloud EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): $title" \
            EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/728" ~/buster-fast-bench/exclusive.sh "$@" 2>&1)
        echo "== exit $? at $(date -u +%FT%TZ)"
    } >> "$D/$log"
}
tool=$(ls -d ~/buster-fast-bench/unclaimed-perf-20261028/toolchain-clang2314/buster/benchpress-clang/*/ | head -1)
rm -f checker-clang.txt
echo "toolchain: $tool $("$tool/bin/clang" --version | head -1)" >> checker-clang.txt
run_in head-a checker-clang.txt "test-checker on head-a, clang 23.1.1" ./build/compiler test-checker --seed 133
run_in head-c checker-clang.txt "test-checker on head-c, clang 23.1.4" env PATH="$tool/bin:$PATH" LD_LIBRARY_PATH="$tool/lib" BUSTER_CLANG_RESOURCE_DIR="$tool/lib/clang/23" ./build/compiler test-checker --seed 133
echo "checker-clang done $(date -u +%FT%TZ)" >> chain.out
