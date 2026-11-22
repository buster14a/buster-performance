#!/bin/bash
# stage.sh NAME ROUNDS EXE...: ROUNDS rounds of round.sh, each under the 9700X's lock alone (#3261).
set -u
D=~/buster-fast-bench/3044-claude
name=$1; rounds=$2; shift 2
export EXCLUSIVE_OWNER=claude-3261 EXCLUSIVE_TITLE='PR sweep: #3261 foreign strings cost' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3261
mkdir -p $D/results $D/out
for exe in "$@"; do test -x $exe || { echo "missing $exe"; exit 1; }; done
echo "== stage $name start $(date -u +%FT%TZ) $*"
for r in $(seq 1 $rounds); do
    ~/buster-fast-bench/exclusive.sh $D/round.sh $name $r "$@" 2>> $D/results/$name.lock
done
echo "stage $name done $(date -u +%FT%TZ)"
