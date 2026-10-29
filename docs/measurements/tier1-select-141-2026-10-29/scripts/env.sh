# #141's Tier 1 selector measurements on the 9700X: main and the head, each a tree named for its commit with a COMMIT
# file. Sourced by the other scripts; every build and run takes the shared lock on its own.
export LC_ALL=C
B=$HOME/buster-fast-bench/tier1-select-141-claude
T=$B/trees
M=$B/m
mkdir -p $M
export EXCLUSIVE_OWNER=claude-141
export EXCLUSIVE_TITLE="#141: Tier 1's batched immediates and load folds, measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/141
X=$HOME/buster-fast-bench/exclusive.sh
MAIN=$(cat $B/main.name)
HEAD=$(cat $B/head.name)
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
