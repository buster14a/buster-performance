#!/bin/bash
# queue.sh: the record's runs on benchpress, each one hold of the lock, in order.
S=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad
run() { echo "== $*"; $S/bp.sh "$@" 2>&1 | grep -v "waiting for"; }
run compare musl 1 on
run compare glibc 1 on
for r in 1 2 3 4 5; do run time musl 1 $r; run time glibc 1 $r; done
run profile musl on final
run profile musl off final
run compare musl 1 verify
run compare musl 1 verify -g
run compare musl 1 on -Wall -Wextra
run compare musl 1 verify -Wall -Wextra
run compare musl 8 on
run compare musl 8 verify
run compare glibc 8 on
run compare sqlite2 1 on
run scalar musl 1
run scalar glibc 1
for r in 1 2 3; do run time musl 8 $r; run time glibc 8 $r; done
for r in 1 2 3 4 5; do run sqlite $r; run small $r; done
echo "== done"
