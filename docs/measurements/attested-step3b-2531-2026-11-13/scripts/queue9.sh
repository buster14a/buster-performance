#!/bin/bash
# queue9.sh: step 3's second part on benchpress: build head (the branch), b38 and h38 (main and head with #2638's
# patch) and p6 (head with the probe), then the comparisons, the probe and the rounds, a few short steps a hold.
S=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad
run() { echo "=== hold: $*"; $S/bp3b.sh batch "$@" 2>&1 | grep -E "^(== |=== |musl |glibc |sqlite2 |attested declarations|## |[0-9a-f]{64} |Linux |model name|performance|\[always\]|clang version|perf version|20[0-9][0-9]-|PROBE|status)" | cut -c1-400; }
for t in head b38 h38 p6; do
    echo "=== build $t"
    timeout 14400 tailscale ssh david@benchpress "cd ~/buster-fast-bench/2531-step3b-claude && EXCLUSIVE_OWNER=claude-2531-step3b EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 ./build.sh $t" 2>&1 | grep -E "status|error" | tail -2
done
run "env" "compare musl 1 on" "compare glibc 1 on" "scalar musl 1"
run "scalar glibc 1" "compare musl 1 verify" "compare musl 1 on -Wall -Wextra" "compare sqlite2 1 on"
run "compare musl 8 on" "compare glibc 8 on" "compare musl 1 verify -g"
run "compare glibc 1 verify" "compare glibc 8 verify"
run "probe musl on f1 p6" "probe glibc on f1 p6" "probe musl on f2 p6" "probe glibc on f2 p6"
for r in 1 2 3 4 5 6 7; do run "trees musl 1 $r base:off base head b38:off b38 h38" "trees glibc 1 $r base:off base head b38:off b38 h38"; done
for r in 1 2 3 4 5 6 7; do run "trees musl 8 $r base head" "trees glibc 8 $r base head"; done
for r in 1 2 3 4 5; do run "sqlite $r" "small $r"; done
echo "=== done"
