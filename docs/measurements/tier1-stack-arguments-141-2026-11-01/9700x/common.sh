# common.sh: sourced by the scripts below (#141's remaining work on the 9700X: the plan's verification first).
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-141-remaining || exit 1
export EXCLUSIVE_OWNER=claude-141-remaining
export EXCLUSIVE_TITLE="#141 remaining work: Tier 1 selection (Claude, cloud session)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQvGuFQQeK4ucco7fRM
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
CTS=$HOME/buster-fast-bench/claude-435/c-testsuite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
RUNDIR=/tmp/claude-141-remaining
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
LUA_SCRIPTS=$HOME/buster-fast-bench/claude-141-reciprocal/lua
