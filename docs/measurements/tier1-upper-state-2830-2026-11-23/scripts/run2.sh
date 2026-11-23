#!/usr/bin/env bash
# run2.sh: the second pass, at the head that predicts the upper state (head.patch's last commit). The first pass's
# head is bin/head-first and its results out-first/ (its corpus fetch ran before the tree existed, so its SQLite
# compiles and programs failed). Builds the new head, fetches CI's corpus, then forms, kernels, compile time and the
# programs, each in lock holds of its own.
set -u
source "$(dirname "$0")/common.sh"
cd $W || exit 1
echo "run2 $(date -u +%FT%TZ)" >> progress.txt
mkdir -p out-first
[ -f bin/head-first ] || mv bin/head bin/head-first
for d in forms kernels compile programs; do [ -d out/$d ] && mv out/$d out-first/; done
git -C tree checkout -q --detach "$(cat out/commit-base.txt)" && git -C tree -c user.name=claude -c user.email=noreply@anthropic.com am -q < head.patch && git -C tree rev-parse HEAD > head-commit.txt
./build.sh head "$(cat head-commit.txt)"; echo "built head2 $(date -u +%FT%TZ)" >> progress.txt
rm -rf tree/build/cmake
[ -d corpus/sqlite ] || BUSTER_CI_CACHE=$HOME/.cache/buster/ci bash tree/tools/ci/fetch-corpus.sh corpus > out/corpus.log 2>&1
ls corpus/sqlite >> out/corpus.log 2>&1
{ cat out/commit-*.txt; sha256sum bin/*; } > out/env2.txt 2>&1
./forms.sh; echo "forms2 $(date -u +%FT%TZ)" >> progress.txt
./kernels.sh; echo "kernels2 $(date -u +%FT%TZ)" >> progress.txt
./compile.sh; echo "compile2 $(date -u +%FT%TZ)" >> progress.txt
./programs.sh base; echo "programs base $(date -u +%FT%TZ)" >> progress.txt
./programs.sh head; echo "programs head $(date -u +%FT%TZ)" >> progress.txt
echo done > run2.done
