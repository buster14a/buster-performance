#!/bin/bash
# Compile times on CPU 2, 11 rounds of the four builds in a rotating order: each compiler's sqlite3.c and speedtest1.c
# to objects, then their link, and the direct path's build of both as one translation unit (compile.times, in
# microseconds). Each output must be the build step's, byte for byte.
set -u
. "$(dirname "$0")/st-env.sh"
cd $M || exit 1
rm -rf ct && mkdir -p ct
t() { # command... -> microseconds, or "failed"
    local s=$EPOCHREALTIME
    "$@" > /dev/null 2>&1 || { echo failed; return; }
    local e=$EPOCHREALTIME
    echo "$(( ${e/./} - ${s/./} ))"
}
: > compile.times
for r in $(seq 0 10); do
    for i in 0 1 2 3; do
        c=${BUILDS[$(( (r + i) % 4 ))]}
        if [ $c = direct ]; then
            echo "direct build $(t direct ct/st-direct)" >> compile.times
        else
            echo "$c sqlite3.c $(t compile $c $Q/sqlite3.c ct/$c-sqlite3.o)" >> compile.times
            echo "$c speedtest1.c $(t compile $c $SRC/speedtest1.c ct/$c-speedtest1.o)" >> compile.times
            echo "$c link $(t link $c ct/st-$c ct/$c-speedtest1.o ct/$c-sqlite3.o)" >> compile.times
        fi
    done
done
for f in ct/*; do
    cmp -s $f $(basename $f) || echo "$f differs from the build step's"
done
median() { sort -n | awk '{v[NR]=$1} END {printf "%d", v[int((NR+1)/2)]}'; }
for step in "ours sqlite3.c" "ours speedtest1.c" "ours link" "direct build" "clang sqlite3.c" "clang speedtest1.c" "clang link" "tcc sqlite3.c" "tcc speedtest1.c" "tcc link"; do
    echo "$step: $(grep "^$step " compile.times | cut -d' ' -f3 | median) us (median of $(grep -c "^$step " compile.times))"
done
