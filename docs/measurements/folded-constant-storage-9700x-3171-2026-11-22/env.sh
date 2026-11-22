# Shared settings for the #3171 (#3022) runs on the 9700X (sourced by the other scripts).
export EXCLUSIVE_OWNER=claude-3171
export EXCLUSIVE_TITLE='PR sweep: #3171 ABA timing'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3171
W="$HOME/buster-fast-bench/3022-claude"
LOCK="$HOME/buster-fast-bench/exclusive.sh"
SQLITE=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
SQLITE_SHA256=0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d
BASE=2e4eb0036803d6ed60da3445586485c5d4a5286b
HEAD=05c2d6ba58ddb64bb018d222471cd26ac4d7600d
# The 9700X job's sqlite3.c -c options (9700x.yml, "Compare check-expressions with the pull request's base").
OPTIONS=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$SQLITE" "$SQLITE/sqlite3.c")
export TMPDIR="$W/tmp"
mkdir -p "$TMPDIR" "$W/bin" "$W/logs"
