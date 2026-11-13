#!/bin/bash
# queue2.sh: the record's runs on benchpress, a few steps a hold of the lock (each hold under a minute).
S=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad
run() { echo "=== hold: $*"; $S/bp.sh batch "$@" 2>&1 | grep -v "waiting for"; }
run "env" "compare glibc 1 on"
for r in 1 2 3 4 5; do run "time musl 1 $r" "time glibc 1 $r"; done
run "profile musl on final" "profile musl off final"
run "compare musl 1 verify" "compare musl 1 verify -g" "compare musl 1 on -Wall -Wextra" "compare musl 1 verify -Wall -Wextra"
run "compare musl 8 on" "compare musl 8 verify" "compare glibc 8 on" "compare glibc 1 verify"
run "compare sqlite2 1 on" "scalar musl 1" "scalar glibc 1"
for r in 1 2 3; do run "time musl 8 $r" "time glibc 8 $r"; done
for r in 1 2 3 4 5; do run "sqlite $r" "small $r"; done
echo "=== done"
