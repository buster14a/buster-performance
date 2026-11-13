#!/bin/bash
# queue4.sh: step 3 against main without attested declarations (base:off), main and the branch: five rounds each corpus.
S=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad
run() { echo "=== hold: $*"; $S/bp3.sh batch "$@" 2>&1 | grep -E "^(== |=== )"; }
for r in 1 2 3 4 5; do run "trees musl 1 $r base:off base head" "trees glibc 1 $r base:off base head"; done
echo "=== done"
