#!/bin/bash
# one-hold.sh T CONFIG ROUND OBJECTS SETTING...: gate2.sh's locked run: each setting's --tier1 -c of sqlite3.c, Lua and
# musl on CPU 2, ticks into T/ticks/CONFIG-NAME-ROUND.txt, objects into OBJECTS/NAME in round 1.
set -uo pipefail
T=$1; config=$2; round=$3; objects=$4; shift 4
D=~/buster-fast-bench/2924-c9h
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$HOME/buster-fast-bench/2924-c-df-claude/c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
EXTRA=; [ $config = all ] && EXTRA=--tier1-passes=+all
for setting in "$@"; do
    exe=$D/compiler-${setting%%:*}; scalar=${setting##*:}; name=${setting/:/-}
    out=$objects/t; [ $round = 1 ] && out=$objects/$config-$name
    ticks=$T/ticks/$config-$name-$round.txt
    rm -f $ticks
    mkdir -p $out/sqlite $out/lua $out/musl
    export BUSTER_SSA_PROMOTE_SCALAR=$scalar BUSTER_SSA_PROMOTE_TICKS=$ticks
    s0=$(date +%s%N)
    (cd $out/sqlite && taskset -c 2 "$exe" -c --tier1 $EXTRA --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o sqlite3.o > /dev/null 2>>$T/logs/err.txt); a=$?
    (cd $out/lua && taskset -c 2 "$exe" -c --tier1 $EXTRA --lanes 1 "$lua"/*.c > /dev/null 2>>$T/logs/err.txt); b=$?
    (cd $out/musl && taskset -c 2 "$exe" -c --tier1 $EXTRA --lanes 1 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}" > /dev/null 2>>$T/logs/err.txt); c=$?
    echo "$config $name $round: sqlite $a lua $b musl $c $(( ($(date +%s%N) - s0) / 1000000 )) ms"
    [ $round = 1 ] || rm -rf $out
done
