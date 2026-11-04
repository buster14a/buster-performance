# common.sh: sourced by the scripts below (#1116 on the 9700X: Tier 1's 32-bit moves and call saves).
set -u
export LC_ALL=C
cd ~/buster-fast-bench/1116-claude || exit 1
export EXCLUSIVE_OWNER=1116-claude
export EXCLUSIVE_TITLE="#1116: Tier 1 code quality on Lua (Claude Code desktop session)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1116
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
RUNDIR=/tmp/1116-claude
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
LUA_SCRIPTS=$HOME/buster-fast-bench/claude-141-reciprocal/lua
