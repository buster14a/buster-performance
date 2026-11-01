# common.sh: sourced by the scripts below (#141's reciprocal division and Done-when measurements on the 9700X).
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-141-reciprocal || exit 1
export EXCLUSIVE_OWNER=claude-141-reciprocal
export EXCLUSIVE_TITLE="#141 reciprocal division and Done-when (Claude, cloud session)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQvGuFQQeK4ucco7fRM
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
CTS=$HOME/buster-fast-bench/claude-435/c-testsuite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
RUNDIR=/tmp/claude-141-st
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
