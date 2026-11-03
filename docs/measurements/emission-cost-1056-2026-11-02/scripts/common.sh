export EXCLUSIVE_OWNER=claude-1056 EXCLUSIVE_TITLE="#1056: no-debug compile cost of PR #1145" EXCLUSIVE_LINK="https://claude.ai/code/session_01TiDLnskdNJZGNsEWwi4BGK"
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/1056-claude
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
sqlite_options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
musl_flags=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
musl_files=("$musl"/src/string/*.c)
shifts="0 704 1408 2112 2752 3456"
