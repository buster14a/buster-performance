#!/bin/bash
set -e
B=$HOME/buster-fast-bench/2089-claude
mkdir -p $B/trees $B/logs
cd $B/trees
src=$(ls -d $HOME/buster-fast-bench/*/trees/*/.git 2>/dev/null | head -1); src=${src%/.git}
for pair in "$@"; do
  name=${pair%%:*}; rev=${pair#*:}
  if [ ! -d $name ]; then git clone -q --reference $src https://github.com/buster14a/buster $name; fi
  git -C $name fetch -q origin main claude/parser-limit-flake-2089 2>/dev/null || git -C $name fetch -q origin main
  git -C $name fetch -q origin $rev 2>/dev/null || true
  git -C $name checkout -q $rev
  git -C $name rev-parse HEAD > $name/COMMIT
  echo "$name $(cat $name/COMMIT)"
done
