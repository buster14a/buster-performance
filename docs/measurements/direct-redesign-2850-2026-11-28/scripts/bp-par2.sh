#!/bin/bash
# front_par built from the record's final sources (the chunks' scan and join moved into scan.h after bp-par.sh's
# runs; no other change): 8 lanes and 1 lane once more, and the chunked scan's check on the corpus's sqlite3.c.
cd /tmp/2850-fermat
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
run() { name=$1; shift; env EXCLUSIVE_OWNER=claude-fermat-16yme8 EXCLUSIVE_TITLE="Direct path performance redesign: $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850 timeout -k 5 300 ~/buster-fast-bench/exclusive.sh "$@"; }
: > par2.out
run "front prototype, 8 lanes" ./front_par.new dump $S 51 8 --cpus 2,3,4,5,6,7,0,1 2>&1 | grep -a -E "^rounds|^its parts|^the lanes|^pass|^events|SAME|DIFFERS|^source|^check|^front_par" | sed "s/^/lanes 8 cold: /" >> par2.out
run "front prototype, 1 lane" ./front_par.new dump $S 51 1 --cpus 2 2>&1 | grep -a -E "^rounds|^its parts|^the lanes|^pass|^events|SAME|DIFFERS|^source|^check|^front_par" | sed "s/^/lanes 1 cold: /" >> par2.out
touch par2.done
