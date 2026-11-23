#!/bin/bash
# census.sh COMPILER OUT: measure-attested of musl's units and of sqlite with --twins and the dump.
compiler=$1; out=$2
musl=/tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/libc/musl
mapfile -t sources < /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/musl-units.txt
musl_options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/musl-generated/obj/include -I $musl/include)
mkdir -p $out/t && cd $out/t
BUSTER_DEBUG_ATTESTED=1 $compiler measure-attested --twins "${musl_options[@]}" -c "${sources[@]}" > $out/musl.txt 2> $out/musl.err; echo "musl $?"
BUSTER_DEBUG_ATTESTED=1 $compiler measure-attested --twins -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/sqlite -c /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/sqlite/sqlite3.c /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/sqlite/shell.c > $out/sqlite.txt 2> $out/sqlite.err; echo "sqlite $?"
