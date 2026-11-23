#!/bin/bash
# The instructions' baseline as the 9700X job's build counts them: main REV built as CI builds it (BUSTER_HOST_ARCH=znver5,
# BUSTER_DEBUG_INFO=0), then the job's own measure-compile arguments, three runs.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
rev=$1
git -C src fetch -q origin
full=$(git -C src rev-parse "$rev")
short=${full:0:9}
tree=trees/$short-ci
[[ -d $tree ]] || git -C src worktree add -q --detach "$PWD/$tree" "$full"
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: build main $short as CI builds it, for the instructions' baseline" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
(cd $tree && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --config Release --target compiler) > $tree-build.log 2>&1
echo "build exit $?"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_TITLE="#2850: count -c sqlite3.c's instructions at $short (three runs)"
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 $tree/build/compiler measure-compile --runs 3 -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > results/base-$short.txt 2> results/base-$short.err
grep -E "^run [0-9]+ default|^default: median|failures" results/base-$short.txt
echo job-complete
