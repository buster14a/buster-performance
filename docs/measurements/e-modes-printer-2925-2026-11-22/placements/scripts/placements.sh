#!/bin/bash
# #2925's A/B over placements and copies: time-runs of whole -E -P and -E processes of main.c, each build at six
# placements of the -E unit's code, three fresh copies each, in a Williams order, the base's executables a second time
# as the comparison's own floor (base-again); ab runs 3 rounds, each under the lock alone, pinned to CPU 2.
set -u
D=~/buster-fast-bench/1380-claude-2925
NAME=${1:?usage: placements.sh NAME [TREE...]}
shift
trees=("$@")
[ ${#trees[@]} -gt 0 ] || trees=(base head)
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
shifts=${SHIFTS:-"0 704 1408 2112 2816 3520"}
builds=()
for b in "${trees[0]}:${trees[0]}" "${trees[1]}:${trees[1]}" "${trees[0]}-again:${trees[0]}"; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$D/shifts/${b#*:}/compiler-$s"); done
done
mkdir -p /dev/shm/1380-claude-2925/copies
cd $D/head
flags="-march=native -Isrc -fwrapv -funsigned-char"
echo "== placements $NAME start $(date -u +%FT%TZ)"
./build/compiler ab --rounds 3 --cpu 2 --lock $D/lockps.sh ./build/compiler \
    -- time-runs --runs 3 --copies 3 --directory /dev/shm/1380-claude-2925/copies "${builds[@]}" \
    --list -E -P $flags src/buster/compiler/main.c --list -E $flags src/buster/compiler/main.c > $D/placements-$NAME.log 2>&1
echo "placements $NAME exit $? $(date -u +%FT%TZ)"
