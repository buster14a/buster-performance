# common.sh: sourced by the scripts below (buster#141: the x86 builtins' scalar bit manipulations as IR intrinsics,
# through Tier 1, on the 9700X).
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-141-intrinsics || exit 1
export EXCLUSIVE_OWNER=claude-141-intrinsics
export EXCLUSIVE_TITLE="#141: x86 builtins' bit manipulations as IR intrinsics through Tier 1 (Claude, cloud session)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngjgJAaQXFcWg7VYzL
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
RUNDIR=/tmp/claude-141-intrinsics
TREES="main-48ac6d71 head-b37f0d25"
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
