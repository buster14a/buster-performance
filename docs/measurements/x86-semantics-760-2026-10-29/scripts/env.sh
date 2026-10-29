# #760's measurements on the 9700X: main and the PR's head (main merged), each a tree named for its commit with a COMMIT
# file. Sourced by the other scripts; every build, benchmark and run takes the shared lock on its own.
export LC_ALL=C
B=$HOME/buster-fast-bench/x86-semantics-760-claude
T=$B/trees
M=$B/m
mkdir -p $M
export EXCLUSIVE_OWNER=claude-760
export EXCLUSIVE_TITLE="solve #760: x86 semantics of the X86 rows' VEX and EVEX forms, measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/760
X=$HOME/buster-fast-bench/exclusive.sh
MAIN=$(cat $B/main.name)
HEAD=$(cat $B/head.name)
# The CI's frozen sqlite3.c and its options (9700x.yml's backend-source step).
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
# The 9700X job's compile-time step's -c of the same file (measure-compile's options).
COMPILE=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$CORPUS/sqlite" "$CORPUS/sqlite/sqlite3.c")
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
