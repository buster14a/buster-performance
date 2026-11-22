#!/bin/bash
# #2925's in-process A/B over placements: benchmark-preprocessor (the vectorized kernels, 21 passes after a warm-up)
# on main.c, -E -P's printing and -E's with line markers, run by each placement's executable of base, head and base's
# again (6 shifts of the -E unit's code each, 18 executables), in a Williams order over them, 2 rounds, each run under
# the lock alone, pinned to CPU 2.
set -u
D=~/buster-fast-bench/1380-claude-2925
NAME=${1:?usage: inproc.sh NAME [BASE HEAD]}
base=${2:-base}
head=${3:-head}
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
shifts=${SHIFTS:-"0 704 1408 2112 2816 3520"}
mkdir -p $D/exe-$NAME
exes=()
for b in "$base:$base" "$head:$head" "$base-again:$base"; do
    for s in $shifts; do
        ln -f $D/shifts/${b#*:}/compiler-$s $D/exe-$NAME/${b%%:*}-$s
        exes+=($D/exe-$NAME/${b%%:*}-$s)
    done
done
cd $D/head
flags="-march=native -Isrc -fwrapv -funsigned-char"
echo "== inproc $NAME start $(date -u +%FT%TZ)"
./build/compiler ab --rounds 2 --cpu 2 --lock $D/lockps.sh "${exes[@]}" \
    -- benchmark-preprocessor --only vectorized $flags src/buster/compiler/main.c \
    -- benchmark-preprocessor --only vectorized --markers $flags src/buster/compiler/main.c > $D/inproc-$NAME.log 2>&1
echo "inproc $NAME exit $? $(date -u +%FT%TZ)"
