#!/bin/bash
# one.sh COMPILER FILE [extra flags...]: default -c against --no-direct; prints SAME/DIFF, the direct object's writer.
c=$1; f=$2; shift 2
d=$(mktemp -d)
"$c" -c -std=gnu17 "$@" "$f" -o $d/d.o 2> $d/d.err; ds=$?
"$c" --no-direct -c -std=gnu17 "$@" "$f" -o $d/f.o 2> $d/f.err; fs=$?
w=$(readelf -p .comment $d/d.o 2>/dev/null | grep -o -E 'buster direct|buster-fast' | head -1)
if [ $ds = $fs ] && cmp -s $d/d.err $d/f.err; then r=SAME; else r=DIFF; fi
printf '%s %-40s direct=%s full=%s writer=%s warn=%s\n' $r "$(basename $f)" $ds $fs "${w:-none}" "$(grep -c warning: $d/f.err)"
[ "$r" = DIFF ] && [ -n "$VERBOSE" ] && { echo "--- direct"; cat $d/d.err; echo "--- full"; cat $d/f.err; }
rm -rf $d
