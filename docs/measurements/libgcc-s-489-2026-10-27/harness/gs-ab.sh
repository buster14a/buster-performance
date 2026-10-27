#!/bin/bash
# The 9700X A/B for #489's review: PR #511's merge base with main and its head, each tree synced (git archive) and built
# under its own hold of the lock, then the benchmarks (gs-bench.sh) and the whole-process runs (gs-proc.sh).
set -e
S=$(dirname "$0")
R=/home/user/buster
BASE=e04462c12f1ce25c70e41e8aa4acf48f4d7c4004
HEAD=e77913290d25356a026abe28ecc466b3094ec3f6
filter() { grep -v "^exclusive.sh: waiting\|^  title:\|^  link:\|^  pull request:"; }
ssh_() { timeout "$1" tailscale ssh david@benchpress "$2"; }
ssh_ 300 'cd ~/buster-fast-bench && mkdir -p libgcc-s-489-main libgcc-s-489-claude && rm -rf libgcc-s-489-main/{src,tests,build.sh} libgcc-s-489-claude/{src,tests,build.sh}'
git -C $R archive $BASE build.sh src tests | ssh_ 300 'tar xf - -C ~/buster-fast-bench/libgcc-s-489-main'
git -C $R archive $HEAD build.sh src tests | ssh_ 300 'tar xf - -C ~/buster-fast-bench/libgcc-s-489-claude'
for d in libgcc-s-489-main libgcc-s-489-claude; do
    ssh_ 1800 "cd ~/buster-fast-bench/$d && EXCLUSIVE_OWNER=claude-libgcc-s-489 EXCLUSIVE_TITLE='Solve 489' EXCLUSIVE_LINK='https://github.com/buster14a/buster/pull/511' BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; status=\$?; tail -1 build.log; echo \"$d build status \$status\"; sha256sum build/compiler" 2>&1 | filter
done
cat $S/gs-bench.sh | ssh_ 300 'cat > ~/buster-fast-bench/libgcc-s-489-bench.sh && chmod +x ~/buster-fast-bench/libgcc-s-489-bench.sh'
cat $S/gs-proc.sh | ssh_ 300 'cat > ~/buster-fast-bench/libgcc-s-489-proc.sh && chmod +x ~/buster-fast-bench/libgcc-s-489-proc.sh'
ssh_ 5400 '~/buster-fast-bench/libgcc-s-489-bench.sh' 2>&1 | filter
ssh_ 3500 '~/buster-fast-bench/libgcc-s-489-proc.sh' 2>&1 | filter
