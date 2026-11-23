#!/bin/bash
compiler=$1; out=$2; shift 2
musl=/tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/libc/musl
mapfile -t sources < /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/musl-units.txt
musl_options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I /tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad/corpus/musl-generated/obj/include -I $musl/include)
rm -rf $out; mkdir -p $out
(cd $out && BUSTER_DEBUG_ATTESTED=1 $compiler --lanes 1 "$@" "${musl_options[@]}" -c "${sources[@]}" > stdout.txt 2> diagnostics.err; echo $? > status.txt)
