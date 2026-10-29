# #181's inc/dec measurements on the 9700X: main and the head, each a tree named for its commit with a COMMIT file.
# Sourced by the other scripts; every build and run takes the shared lock on its own.
export LC_ALL=C
B=$HOME/buster-fast-bench/x86-zen5-181-claude
T=$B/trees
M=$B/m
mkdir -p $M
export EXCLUSIVE_OWNER=claude-181
export EXCLUSIVE_TITLE="#181: inc and dec against add and sub on Zen 5, measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/181
X=$HOME/buster-fast-bench/exclusive.sh
MAIN=$(cat $B/main.name)
HEAD=$(cat $B/head.name)
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
COMPILE=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$CORPUS/sqlite" "$CORPUS/sqlite/sqlite3.c")
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
