#!/bin/bash
cd $(dirname $0)
while pgrep -x corpora.sh > /dev/null || pgrep -x run-final.sh > /dev/null; do sleep 10; done
./measure2.sh 2044025c claude/trusting-ramanujan-0q09lz 2044025cc - annotate
rm -rf src/build
./corpora.sh 2044025c
