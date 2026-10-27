# The frozen corpus's sqlite3.c with #136's speedtest1 record's options, as #520's step (docs/compile-time.md) compiles it.
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
events=task-clock,cycles:u,instructions:u,cycles:k,instructions:k
