#!/usr/bin/env bash
# rerun.sh: after the Release builds, each PR tree's Develop build published again, then its blocks rerun
# (the first run's ownership and c-testsuite blocks failed on the harness: a copied executable, no c-testsuite).
set -uo pipefail
. "$HOME/buster-fast-bench/3130-claude/env.sh"
cd "$W"
for n in 3130 3143; do
    echo "== $n $(date -u -Iseconds)"
    ./build-one.sh w$n Develop $n-develop-again
    cmp bin/$n-develop bin/$n-develop-again && echo "the Develop build is the first run's bytes"
    cp bin/$n-develop-again bin/$n-develop
    ./tests.sh w$n $n-develop
    mv logs/tests-$n-develop.log logs/tests-$n-develop-rerun.log
done
touch rerun.done
