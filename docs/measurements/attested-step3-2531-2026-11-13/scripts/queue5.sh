#!/bin/bash
# queue5.sh: step 3's gate runs on benchpress (head = the branch's 3d43ecec, base = main 26f0bb0e).
S=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad
run() { echo "=== hold: $*"; $S/bp3.sh batch "$@" 2>&1 | grep -E "^(== |=== |musl |glibc |sqlite2 |attested declarations|## |[0-9a-f]{64} |Linux |model name|performance|\[always\]|clang version|perf version|20[0-9][0-9]-)"; }
run "env" "compare musl 1 on" "compare glibc 1 on" "scalar musl 1"
run "scalar glibc 1" "compare musl 1 verify" "compare musl 1 on -Wall -Wextra" "compare sqlite2 1 on"
run "compare musl 8 on" "compare glibc 8 on" "compare musl 1 verify -g"
for r in 1 2 3 4 5; do run "trees musl 8 $r base:off base head" "trees glibc 8 $r base:off base head"; done
for r in 1 2 3 4 5; do run "sqlite $r" "small $r"; done
echo "=== done"
