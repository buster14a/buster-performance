#!/bin/bash
# compile.sh COMPILER OUT MODE...: musl's units as one command, and sqlite3.c alone with a memo (cold then warm), into OUT.
compiler=$1; out=$2; shift 2
musl=/tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/libc/musl
mapfile -t sources < /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/musl-units.txt
musl_options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/musl-generated/obj/include -I $musl/include)
sqlite_options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/sqlite)
rm -rf $out; mkdir -p $out/musl $out/sqlite $out/memo
(cd $out/musl && BUSTER_DEBUG_ATTESTED=1 $compiler "$@" "${musl_options[@]}" -c "${sources[@]}" > stdout.txt 2> diagnostics.err; echo $? > status.txt)
(cd $out/sqlite && $compiler "$@" --attested-memo=$out/memo "${sqlite_options[@]}" -c /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/sqlite/sqlite3.c > cold.txt 2> cold.err; echo $? > cold.status; mv sqlite3.o cold.o)
(cd $out/sqlite && BUSTER_DEBUG_ATTESTED=1 $compiler "$@" --attested-memo=$out/memo "${sqlite_options[@]}" -c /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/sqlite/sqlite3.c > stdout.txt 2> diagnostics.err; echo $? > status.txt)
