# #221's measurements on the 9700X: main (9bb5060e), the PR's head (cff7bc98, main merged) and nosub (the head without the form
# choice's substitutions: inc, dec, xor, test r, r and the narrower test). Sourced by the other scripts; every build,
# benchmark and run takes the shared lock on its own.
export LC_ALL=C
B=$HOME/buster-fast-bench/x86-semantics-221-claude
T=$B/trees
M=$B/m
mkdir -p $M
export EXCLUSIVE_OWNER=claude-221
export EXCLUSIVE_TITLE="solve #221: x86 semantics consumers, measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/221
X=$HOME/buster-fast-bench/exclusive.sh
# The CI's frozen sqlite3.c and its options (9700x.yml's backend-source step).
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SQLITE=(--predefines "$CORPUS/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$CORPUS/headers/usr/lib/clang/23/include" -isystem "$CORPUS/headers/usr/local/include" -isystem "$CORPUS/headers/usr/include" "$CORPUS/sqlite/sqlite3.c")
# The 9700X job's compile-time step's -c of the same file (measure-compile's options).
COMPILE=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$CORPUS/sqlite" "$CORPUS/sqlite/sqlite3.c")
# speedtest1's sources and flags, #136's harness's (SQLite's test/speedtest.tcl at 3.53.2).
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
RUNDIR=/tmp/speedtest1-221-claude
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
