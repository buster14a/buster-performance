#!/bin/bash
# warnings.sh: sqlite3.c's -c by the PR's head with its warnings, with -Wno-empty-body (without #1339's one warning) and
# with -w, 3 each, under the 9700X's lock: check-program's and the total's times by --time-stages, and the warnings.
# As run (from ~/buster-fast-bench/151-claude, after final.sh), its output is raw/warnings.txt.
export EXCLUSIVE_OWNER=claude-151 EXCLUSIVE_TITLE="GitHub issue #151" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/151
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for flags in "" "-Wno-empty-body" "-w"; do
  for i in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh taskset -c 0-7 final/build/compiler --time-stages $flags -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /tmp/claude-151-w.o 2>&1 | awk -F"\t" -v f="[$flags]" "\$1==\"time-stage\" && (\$2==\"check-program\" || \$2==\"total\") {printf \"%s %s=%s \", f, \$2, \$3} /warning:/ {w+=1} END {print \"warnings=\" w+0}"
  done
done
