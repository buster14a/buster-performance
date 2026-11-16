#!/bin/bash
# corpora.sh: the three corpora, as buster#2850's other records take them. Sourced by the runners, from this directory.
#   corpus_options CORPUS   prints the corpus's preprocessor options, quoted for a shell
#   corpus_files CORPUS     prints its files, a line each
corpus=${CORPUS_ROOT:-/home/user/buster/build/corpus}
sqlite=$corpus/sqlite
lua=${LUA_SRC:-/root/.cache/claude-2891/inputs/lua-5.4.8/src}
musl=$corpus/libc/musl

corpus_options()
{
    case $1 in
    sqlite3) printf '%q ' -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" ;;
    lua) ;;
    musl) printf '%q ' -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" ;;
    esac
}

corpus_files()
{
    case $1 in
    sqlite3) echo "$sqlite/sqlite3.c" ;;
    lua) ls "$lua"/*.c ;;
    musl)
        # A base name once, the generic file before its x86_64 one, as the other records' lists have it.
        declare -A seen
        for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
            b=${f##*/}
            if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; echo "$f"; fi
        done
        ;;
    esac
}
