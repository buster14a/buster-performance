#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/issue587-codex-20261027"
export EXCLUSIVE_OWNER=codex-issue587
export EXCLUSIVE_TITLE='Measure typeof swizzle fix (#587)'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/587
export BUSTER_DEBUG_INFO=0
export TMPDIR="$PWD/tmp"
mkdir -p "$TMPDIR" results shifts
while [ ! -f results/fixed-call-graph.rc ]; do sleep 5; done
if [ "$(cat results/fixed-checker.rc)" != 0 ] || [ "$(cat results/fixed-call-graph.rc)" != 0 ]; then
    echo 'qualification failed; measurements not started'
    exit 1
fi
cp src/buster/compiler/c_check_vector_test.c c_check_vector_test.fixed.c
cp c_check_constant.base.c src/buster/compiler/c_check_constant.c
cp c_check_vector_test.base.c src/buster/compiler/c_check_vector_test.c
"$HOME/buster-fast-bench/exclusive.sh" ./build.sh shifts shifts/base main_unit_checker.c 0 688 1376 2064 2752 3440 > results/base-shifts-build.log 2>&1
cp c_check_constant.fixed.c src/buster/compiler/c_check_constant.c
cp c_check_vector_test.fixed.c src/buster/compiler/c_check_vector_test.c
"$HOME/buster-fast-bench/exclusive.sh" ./build.sh shifts shifts/head main_unit_checker.c 0 688 1376 2064 2752 3440 > results/head-shifts-build.log 2>&1
sha256sum -c source-files.sha256 > results/source-verification.log
{
    cat source-info.txt
    date -u
    uname -a
    lscpu
    clang --version
    /usr/bin/wild --version
    sha256sum "$HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c" baseline-compiler fixed-compiler shifts/{base,head}/compiler-*
} > results/identity.log
builds=()
for role in base head base-again; do
    directory=$role
    if [ "$role" = base-again ]; then directory=base; fi
    for shift in 0 688 1376 2064 2752 3440; do
        builds+=(--build "$role" "$PWD/shifts/$directory/compiler-$shift")
    done
done
./fixed-compiler ab --rounds 3 --cpu 2 --lock "$HOME/buster-fast-bench/exclusive.sh" ./fixed-compiler -- time-runs --runs 3 --copies 3 "${builds[@]}" --list -fsyntax-only "$HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c" > results/sqlite.log 2>&1
printf 'measurements complete\n'
