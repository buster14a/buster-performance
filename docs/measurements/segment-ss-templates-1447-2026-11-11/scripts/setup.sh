#!/bin/bash
set -e
B=$HOME/buster-fast-bench/1447-c2b-claude
mkdir -p $B/trees $B/m
cd $B/trees
src=$HOME/buster-fast-bench/1447-c2-claude/trees/base1
for pair in base:1236be12193ad224529e78fb4242474a5ce1e8ba ss:42fdf39a2d67c0dc49113cc7857639c1536fbf38; do
  name=${pair%%:*}; rev=${pair#*:}
  if [ ! -d $name ]; then git clone -q --reference $src https://github.com/buster14a/buster $name; fi
  git -C $name fetch -q origin main claude/segment-ss-encoder
  git -C $name checkout -q $rev
  git -C $name rev-parse HEAD > $name/COMMIT
  echo "$name $(cat $name/COMMIT)"
done
