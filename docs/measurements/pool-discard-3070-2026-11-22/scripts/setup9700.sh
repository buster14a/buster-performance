#!/usr/bin/env bash
set -u
D=$HOME/buster-fast-bench/3070-claude
mkdir -p $D/empty $D/results
cd $D
for i in $(seq 1 1336); do : > empty/e$i.c; done
if [ ! -d base ]; then git clone -q https://github.com/buster14a/buster base; fi
cd base && git fetch -q origin main && git checkout -q --detach e20c6ff9 && git log -1 --format=%h
