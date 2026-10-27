#!/bin/bash
# The whole measurement under two holds of the 9700X's lock: the two trees' compiler builds (about 70 s), then
# st-measure.sh (speedtest1's builds, the compile times, the runs, the counts and the profiles, about 60 s). Started
# detached; its report is m2/measure.log.
cd "$(dirname "$0")" || exit 1
. ./st-env.sh
lock() {
    EXCLUSIVE_OWNER=claude-speedtest1-136 EXCLUSIVE_TITLE="speedtest1 with switch jump tables: Tier 0 before and after (#136)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/136 ~/buster-fast-bench/exclusive.sh "$@"
}
mkdir -p $M
{
    echo "== st-compiler.sh $(date -Is)"
    lock ./st-compiler.sh > $M/build-compiler.log 2>&1 || { echo "a compiler didn't build"; tail $M/build-compiler.log; exit 1; }
    grep 'sources compiled' $M/build-compiler.log
    echo "== st-measure.sh $(date -Is)"
    lock ./st-measure.sh
    echo "== done $(date -Is)"
} > $M/measure.log 2>&1
