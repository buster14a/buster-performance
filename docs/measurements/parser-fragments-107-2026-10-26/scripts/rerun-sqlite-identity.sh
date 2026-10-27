#!/usr/bin/env bash
# The SQLite identity step again: the first run checked a manifest of a relative path from the tree, which failed.
set -u
base=~/buster-fast-bench/claude-fragments-106-107
results=$base/results-7808e811
export EXCLUSIVE_OWNER=claude-fragments-107
export EXCLUSIVE_TITLE="Salter fragments #106: SQLite identity"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/106
echo "$(date -Is) start identity-sqlite-rerun" >> "$results/progress-rerun"
(cd "$base/inputs" && ~/buster-fast-bench/exclusive.sh bash -c "sha256sum --quiet --check sqlite3.sha256 && taskset -c 2 $base/tree-7808e811/build/compiler test-fragments --no-fixtures sqlite3.c") > "$results/identity-sqlite-rerun.log" 2>&1
echo "$(date -Is) end identity-sqlite-rerun status $?" >> "$results/progress-rerun"
