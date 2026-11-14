#!/bin/bash
# run-front.sh: the front-end round's builds and timings, each run in a hold of its own: the pull request's commit (pr) and
# main (m3) built, then three rounds of time.sh over the shifted builds and the two, in turn, then the comparison of pr
# on the corpora and -c sqlite3.c by m3 and pr.
set -u
cd "$(dirname "$0")"
./build-rev.sh pr 050a73cfcc259100a72e6ecba287f04b36ee95a8
./build-rev.sh m3 b7a95eedbe16fbd8434654f192f8f7aab76c56e5
echo "built $(tail -1 results/pr/build.log) $(tail -1 results/m3/build.log)"
for n in 1 2 3; do
    for l in m3 pr only-s0 e1-s0 only-s1024 e1-s1024 only-s2112 e1-s2112 only-s3136 e1-s3136; do
        timeout 300 ./time.sh $l -f$n > /dev/null 2>&1
    done
    echo "round $n"
done
./corpora.sh pr > /dev/null 2>&1
echo corpora
./ab.sh m3 pr > /dev/null 2>&1
echo ab
