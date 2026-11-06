#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 allocation, masks and own-source checks' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
while [ ! -f fixed-v8-tests.done ] || [ ! -f latest-base-programs.done ]; do
    if [ -s fixed-v8-tests.status ] && awk '$2 != 0 { bad = 1 } END { exit !bad }' fixed-v8-tests.status; then exit 1; fi
    sleep 2
done
for suite in test-tier1-liveness test-tier1-masks; do
    "$HOME/buster-fast-bench/exclusive.sh" fixed-v8/build/compiler "$suite" > "fixed-v8-$suite.log" 2>&1
    printf '%s 0\n' "$suite" >> fixed-v8-extra.status
done
for build in latest-base fixed-v8; do
    set +e
    (cd fixed-v8 && "$HOME/buster-fast-bench/exclusive.sh" "../$build/build/compiler" -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c) > "fixed-v8-own-source-$build.log" 2>&1
    status=$?
    set -e
    printf 'own-source-%s %s\n' "$build" "$status" >> fixed-v8-extra.status
done
touch fixed-v8-extra.done
