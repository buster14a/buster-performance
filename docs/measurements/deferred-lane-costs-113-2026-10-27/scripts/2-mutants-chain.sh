#!/bin/bash
# The mutants of the merged tree, one lock hold each (run_mutant.sh builds at -O1 and runs its suites), 30 s apart,
# test-checker-deferred under a timeout of TIMEOUT seconds (the first argument). Writes each NAME.result.
D=/home/david/buster-fast-bench/113-lanes-cloud
M=/home/david/buster-fast-bench/113-lanes-cloud/mutants
echo $$ > "$M/chain.pid"
export EXCLUSIVE_OWNER=claude-113-cloud
export EXCLUSIVE_TITLE="#113 deferred reader lane costs (cloud session): mutants of the merged tree"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6466271358"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
timeout_seconds="$1"
for name in $(python3 -c "import sys; sys.path.insert(0, \"$M\"); from mutants import M; print(\" \".join(m[0] for m in M))"); do
    ~/buster-fast-bench/exclusive.sh "$M/run_mutant.sh" "$name" "$timeout_seconds" > /dev/null 2>> "$M/lock.txt"
    sleep 30
done
echo "done $(date -Is)" >> "$M/done.txt"
