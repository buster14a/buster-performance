#!/bin/bash
# collect.sh: the record's raw files, without objects or perf data, as record.tar.gz.
set -eu
cd ~/buster-fast-bench/2536-step1-claude
./env.sh
rm -rf record && mkdir -p record/raw record/scripts
for d in gauge-main gauge-head1-w0 gauge-head1-w2048 gauge-head3-w0 gauge-head3-w512 gauge-head3-w1024 gauge-head3-w2048 gauge-head3-w4096 gauge-head3-w8192; do
    mkdir -p record/raw/$d/counted record/raw/$d/sampled
    cp $d/whole.tsv $d/table.tsv $d/status.txt $d/counted.log $d/sampled.log $d/table.log record/raw/$d/
    cp $d/counted/*.rows.tsv $d/counted/*.strays.txt record/raw/$d/counted/
    cp $d/sampled/*.rows.tsv $d/sampled/*.strays.txt $d/sampled/*.buckets.tsv record/raw/$d/sampled/
    tar -czf record/raw/$d/counted/stages.tar.gz -C $d/counted $(cd $d/counted && ls -d r*.one r*.eight)
    tar -czf record/raw/$d/sampled/stages.tar.gz -C $d/sampled $(cd $d/sampled && ls -d r*.one r*.eight)
done
./substages.sh gauge-main gauge-head1-w0 gauge-head1-w2048 gauge-head3-w0 gauge-head3-w512 gauge-head3-w1024 gauge-head3-w2048 gauge-head3-w4096 gauge-head3-w8192 > record/raw/substages.txt
mkdir -p record/raw/corpora
cp corpora-head2/summary.txt record/raw/corpora/
[ -f corpora-head2/differences.txt ] && cp corpora-head2/differences.txt record/raw/corpora/ || : > record/raw/corpora/differences.txt
cp corpora-head2/*.files record/raw/corpora/
for c in sqlite lua c-testsuite main musl; do mkdir -p record/raw/corpora/$c; cp corpora-head2/$c/*.status record/raw/corpora/$c/; done
for p in profile-w0 profile-w2048; do
    mkdir -p record/raw/$p
    cp $p/one.symbols.txt $p/eight.symbols.txt record/raw/$p/
    ./compare.sh $p > record/raw/$p/compare.txt
done
mkdir -p record/raw/musl
cp musl-head3/runs.txt musl-head3/*.stat record/raw/musl/
cp env.txt record/raw/
for b in main head1 head2 head3; do tail -3 build-$b.log > record/raw/build-$b.log; done
cp ./*.sh record/scripts/
cp main/tools/allcore/allcore.c record/scripts/allcore.c
(cd record && find . -type f ! -name SHA256SUMS -print0 | sort -z | xargs -0 sha256sum > SHA256SUMS)
tar -czf record.tar.gz record
du -sh record record.tar.gz
