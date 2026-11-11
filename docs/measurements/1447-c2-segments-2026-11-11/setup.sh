#!/bin/bash
set -e
B=$HOME/buster-fast-bench/1447-c2-claude
mkdir -p $B/trees $B/m
cd $B/trees
src=$(ls -d $HOME/buster-fast-bench/*/trees/*/.git 2>/dev/null | head -1); src=${src%/.git}; [ -n "$src" ] && ref="--reference $src" || ref=""
for pair in base1:d43c37e5192d7e5d62df822aa2ce5c1f3facb5ca pr2106:1aff3051e99f2d52981451df5650e0ede85a92ee pr2118:ddae5c3bfc8c6ed94d7b00ea7ac7443abebe9863 base3:2f18cac0d3b48fdcb14405fa4391e5d10f528e89 pr2123:917d164d14503e0dfc29218235d81a0eb57f3be2; do
  name=${pair%%:*}; rev=${pair#*:}
  if [ ! -d $name ]; then git clone -q --reference $src https://github.com/buster14a/buster $name; fi
  git -C $name fetch -q origin main claude/segment-arrow-swizzle-2095 claude/segment-tier1 claude/segment-vector-element
  git -C $name checkout -q $rev
  git -C $name rev-parse HEAD > $name/COMMIT
  echo "$name $(cat $name/COMMIT)"
done
