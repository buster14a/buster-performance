#!/bin/bash
# job.sh LOG TREE COMMAND...: COMMAND in TREE under the 9700X lock (one hold), output and exit status appended to LOG.
D=~/buster-fast-bench/113-lanes-cloud
log="$1"; tree="$2"; shift 2
export EXCLUSIVE_OWNER=claude-113-cloud
export EXCLUSIVE_TITLE="#113 deferred reader lane costs (cloud session): build and tests of the merged tree"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6466271358"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
{
    echo "== $(date -Is) $tree: $*"
    cd "$D/$tree" && ~/buster-fast-bench/exclusive.sh "$@"
    echo "exit=$? $(date -Is)"
} >> "$D/$log" 2>&1
