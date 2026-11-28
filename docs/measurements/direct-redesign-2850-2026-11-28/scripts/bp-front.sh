#!/bin/bash
# The front prototype on sqlite3.c under the lock: its own counters over 51 rounds, then a profile.
cd /tmp/2850-fermat
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
./bp-run.sh "front prototype" ./front dump $S 51 > front.out 2>&1
./bp-run.sh "front prototype profile" perf record -q -e cycles:u -c 20011 -o front.perf ./front dump $S 201 > front-perf.out 2>&1
perf report -i front.perf --stdio --no-children --sort symbol --percent-limit 0.7 2>/dev/null | grep -v "^#" | sed '/^$/d' > front-symbols.txt
touch front.done
