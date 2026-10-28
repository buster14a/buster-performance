# Shared settings of #569's 9700X campaign (sourced by the scripts beside it).
D=$HOME/buster-fast-bench/validate-569-claude
LOCK=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-569 EXCLUSIVE_TITLE="#569 tier0 validator: the switch's modes" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/569
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
export TMPDIR="$D/tmp"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
events=task-clock,cycles:u,instructions:u,cycles:k,instructions:k
modes=(vector scalar none)
