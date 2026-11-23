#!/bin/bash
# build.sh TREE: builds TREE (a directory of ~/buster-fast-bench/1667-claude) Release as the 9700X job does, in a lock hold of its own; logs/build-TREE.txt.
D=~/buster-fast-bench/1667-claude
export EXCLUSIVE_OWNER=claude-1667 EXCLUSIVE_TITLE="buster #1667/#1668: the deferred reader's lane rule (build)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1667
tree=$1
log="$D/logs/build-$tree.txt"
cd "$D/$tree" || exit 1
{ date -Is; git log -1 --format=%H; git diff --stat; } > "$log"
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release >> "$log" 2>&1
echo "exit=$? $(date -Is)" >> "$log"
