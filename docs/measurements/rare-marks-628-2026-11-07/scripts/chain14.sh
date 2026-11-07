#!/bin/bash
# chain14.sh: chain13 again, the default options alone, 9 rounds: chain13's round 2 found the host without huge pages for
# both trees (A 38,151 and B 32,141 faults in check-input), which its medians leave out but its record should not need to.
cd ~/buster-fast-bench/628-claude-tesla
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main5 pr3 ab14 9 -- "${options[@]}" > ab14.log 2>&1
echo chain14-done
