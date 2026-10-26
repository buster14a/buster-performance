#!/bin/bash
# The whole measurement under two holds of the 9700X's lock: the compiler's build (about 35 s), then st-measure.sh
# (speedtest1's builds, the compile times, the runs and the counts, about 70 s). Started detached; its report is
# m/measure.log.
cd "$(dirname "$0")" || exit 1
. ./st-env.sh
lock() {
    EXCLUSIVE_OWNER=claude-speedtest1-136 EXCLUSIVE_TITLE="speedtest1: Tier 0 against clang -O0 and tcc (#136)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/136 ~/buster-fast-bench/exclusive.sh "$@"
}
mkdir -p $M
{
    echo "== st-compiler.sh $(date -Is)"
    lock ./st-compiler.sh > $M/build-compiler.log 2>&1 || { echo "the compiler didn't build"; tail $M/build-compiler.log; exit 1; }
    tail -2 $M/build-compiler.log
    echo "== st-measure.sh $(date -Is)"
    lock ./st-measure.sh
    echo "== done $(date -Is)"
} > $M/measure.log 2>&1
