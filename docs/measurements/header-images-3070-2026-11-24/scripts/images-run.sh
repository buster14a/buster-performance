#!/usr/bin/env bash
# #3070 step 2a: the root image's pull request (pr) and header images on it (NAME), built Release under the lock, then
# measured. usage: images-run.sh NAME PATCH ROUNDS
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
N=$1; P=$2; R=$3
cd $D
export EXCLUSIVE_OWNER=claude-3070-euler EXCLUSIVE_TITLE="#3070 step 2a: header images" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3070
build() { # TREE NAME
    (cd $D/$1 && ~/buster-fast-bench/exclusive.sh timeout -k 5 1500 ./build.sh --config Release > $D/build-$2.log 2>&1; s=$?; echo "build exit $s" >> $D/build-$2.log; [ $s = 0 ] && cp build/compiler $D/bin/$2)
}
if [ ! -x bin/pr ]; then
    git -C base fetch -q origin claude/upbeat-euler-8evs88
    rm -rf pr && git -C base worktree prune && git -C base worktree add -q --detach $D/pr 0b008cf1
    build pr pr
fi
rm -rf $N && cp -r pr $N && rm -rf $N/build $N/.git
(cd $N && git init -q . && git apply --whitespace=nowarn $P) > $D/apply-$N.log 2>&1
echo "apply exit $?" >> $D/apply-$N.log
build $N $N
if [ -x bin/pr ] && [ -x bin/$N ]; then
    ./measure2.sh $R $D/results/$N base=$D/bin/pr on=$D/bin/$N,--header-images=on off=$D/bin/$N,--header-images=off
fi
echo "images-run done" > $D/results/$N-done.txt
