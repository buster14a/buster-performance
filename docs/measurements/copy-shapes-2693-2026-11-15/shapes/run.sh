#!/bin/bash
# One lock hold per source: bench measures every size's shapes in one process (#2693). The timeout is inside the
# hold, so waiting for the lock is unbounded but the run isn't.
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2693 EXCLUSIVE_TITLE="Issue 2693: copy piece shapes" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2693
for source in ${SOURCES:-cold copied far built4}; do
    ~/buster-fast-bench/exclusive.sh timeout 300 taskset -c 2 ./bench $source 0 ${REPEATS:-5} >> results.tsv 2>> run.err
    echo "$source: $?" >> run.status
done
echo done >> run.status
