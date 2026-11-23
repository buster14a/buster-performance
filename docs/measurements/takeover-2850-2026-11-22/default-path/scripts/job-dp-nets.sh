#!/bin/bash
# job-dp-nets.sh: the default path's piece against main on the four corpora, plain and with -Wall -Wextra.
export PATH="$HOME/dev/scripts:$PATH"
D=/tmp/claude-1000/lazy/dp; B=/tmp/claude-1000/lazy/b3
L=https://github.com/buster14a/buster/issues/2850
( CORES_TITLE="#2850: the corpora by main's compiler and the default path's (plain)" CORES_LINK=$L cores -n 1 -- bash $D/corpus-compare.sh $B/snap-main/build/cmake/native/Develop/compiler $B/snap-dp1/build/cmake/native/Develop/compiler $B/snap-dp1 $D/corpus-plain > $D/corpus-plain.log 2>&1; grep -v '^cores:' $D/corpus-plain.log | sed 's/^/plain /' ) &
( CORES_TITLE="#2850: the corpora by main's compiler and the default path's (-Wall -Wextra)" CORES_LINK=$L cores -n 1 -- bash $D/corpus-compare.sh $B/snap-main/build/cmake/native/Develop/compiler $B/snap-dp1/build/cmake/native/Develop/compiler $B/snap-dp1 $D/corpus-wall -Wall -Wextra > $D/corpus-wall.log 2>&1; grep -v '^cores:' $D/corpus-wall.log | sed 's/^/wall /' ) &
wait
echo nets-complete
