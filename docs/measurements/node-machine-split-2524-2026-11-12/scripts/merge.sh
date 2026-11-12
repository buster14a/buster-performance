#!/bin/bash
# merge.sh: main f2faf255, the split merged with main (3878feb1) and the head with calls (f5b919f2): each built, timed
# (time.sh) and compared (corpora.sh), and the head's tests (tests.sh); each run in its own hold of the lock.
set -u
cd "$(dirname "$0")"
git -C src checkout -q --detach f2faf255e64c2551d63b55bf08039da59e31336a && ./build.sh src && ./time.sh f2faf255 src > time-f2faf255.log 2>&1 && ./corpora.sh f2faf255 > corpora-f2faf255.log 2>&1
git -C src checkout -q --detach 3878feb1f4082d2431d0d3b32da2cfdb38014134 && ./build.sh src && cp build-src.log build-3878feb1.log && ./time.sh 3878feb1 src > time-3878feb1.log 2>&1 && ./corpora.sh 3878feb1 > corpora-3878feb1.log 2>&1
./build.sh c27ee009 && cp build-c27ee009.log build-f5b919f2.log && ./time.sh f5b919f2 c27ee009 > time-f5b919f2.log 2>&1 && ./corpora.sh f5b919f2 > corpora-f5b919f2.log 2>&1 && ./tests.sh c27ee009 > tests-f5b919f2.log 2>&1
date -u +%FT%TZ > merge.done
