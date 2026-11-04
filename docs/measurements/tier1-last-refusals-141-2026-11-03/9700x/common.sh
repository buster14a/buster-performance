# common.sh: sourced by the scripts below (buster#1245, #141's last Tier 1 refusals, on the 9700X).
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-141-1245 || exit 1
export EXCLUSIVE_OWNER=claude-141-1245
export EXCLUSIVE_TITLE="#141 buster#1245: thread-locals, 64-byte vector arguments, wide constant indices (Claude, cloud session)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngjgJAaQXFcWg7VYzL
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
RUNDIR=/tmp/claude-141-1245
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
