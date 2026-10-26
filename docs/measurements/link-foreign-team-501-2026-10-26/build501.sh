#!/bin/bash
# build501.sh [TREE...]: #501's executables, as the 9700X job builds them (BUSTER_DEBUG_INFO=0), each build under its
# own hold of the shared lock (all three by default): v0 main 5a5bcd33, v1 the head ad9fc555 (main merged), v2 the head with
# switch501.patch (the workers keep or release their scratch arenas by BUSTER_501_SCRATCH, for the measurement
# alone). Then, unless they are there, the 1-worker program's objects, which benchmark-link writes and --keep keeps,
# from v0's executable. sha256s in builds501.sha256.
set -u
D=~/buster-fast-bench/perf-501-claude
export EXCLUSIVE_OWNER=claude-501
export EXCLUSIVE_TITLE="Solve #501: link-foreign's lane team"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/501
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
trees=("$@")
[ ${#trees[@]} -gt 0 ] || trees=(v0 v1 v2)
for t in "${trees[@]}"; do
    ~/buster-fast-bench/exclusive.sh bash -c "cd $D/$t && BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh" > "build-$t.log" 2>&1
    echo "build $t status $? $(date -Is)" >> build501.log
done
sha256sum v0/build/compiler v1/build/compiler v2/build/compiler > builds501.sha256
if ! ls links1/buster-link-benchmark-*/objects/unit_0.o > /dev/null 2>&1; then
    mkdir -p links1
    ~/buster-fast-bench/exclusive.sh v0/build/compiler benchmark-link --functions 1 --only linkers --linkers link-foreign --kinds dynamic,static --runs 1 --keep --directory "$D/links1" > links1.log 2>&1
    echo "links1 status $? $(date -Is)" >> build501.log
fi
echo "done $(date -Is)" >> build501.log
