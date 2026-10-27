#!/bin/bash
# Compile times on CPU 2, 11 rounds of the six builds in a rotating order: each compiler's sqlite3.c and speedtest1.c
# to objects, then their link, and each direct path's build of both as one translation unit (compile.times, in
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
n=${#BUILDS[@]}
: > compile.times
for r in $(seq 0 10); do
    for i in $(seq 0 $(( n - 1 ))); do
        c=${BUILDS[$(( (r + i) % n ))]}
        case $c in
            *-direct)
                echo "$c build $(t direct $c ct/st-$c)" >> compile.times
                ;;
            *)
                echo "$c sqlite3.c $(t compile $c $Q/sqlite3.c ct/$c-sqlite3.o)" >> compile.times
                echo "$c speedtest1.c $(t compile $c $SRC/speedtest1.c ct/$c-speedtest1.o)" >> compile.times
                echo "$c link $(t link $c ct/st-$c ct/$c-speedtest1.o ct/$c-sqlite3.o)" >> compile.times
                ;;
        esac
    done
done
for f in ct/*; do
    cmp -s $f $(basename $f) || echo "$f differs from the build step's"
done
median() { sort -n | awk '{v[NR]=$1} END {printf "%d", v[int((NR+1)/2)]}'; }
cut -d' ' -f1,2 compile.times | sort -u | while read c step; do
    echo "$c $step: $(grep "^$c $step " compile.times | cut -d' ' -f3 | median) us (median of $(grep -c "^$c $step " compile.times))"
done
