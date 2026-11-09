# #1447's segment overrides on the 9700X: main and the head, each a tree with a COMMIT file. Sourced by the other
# scripts; every build and run takes the shared lock on its own.
export LC_ALL=C
B=$HOME/buster-fast-bench/1447-segments-claude
T=$B/trees
M=$B/m
mkdir -p $M
export EXCLUSIVE_OWNER=claude-1447-segments
export EXCLUSIVE_TITLE="#1447: loads and stores in __seg_fs/__seg_gs, Tier 0 measurements"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvZSkhA86Mvef5bY6Z
X=$HOME/buster-fast-bench/exclusive.sh
MAIN=main-cb608c1f61
HEAD=head-4a2dd72cb5
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SQLITE=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$CORPUS/sqlite" "$CORPUS/sqlite/sqlite3.c")
MAINC_ARGS=(-c -march=native "-I$T/$HEAD/src" -fwrapv -funsigned-char -fno-strict-aliasing "$T/$HEAD/src/buster/compiler/main.c")
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
