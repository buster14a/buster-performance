#!/bin/sh
# benchmark-executable --only $1 at --functions $2: main (68cc356a4, src/) with --exact against head (hexe/, claude/2924-linker-3),
# alternating processes, CPU 2, $3 rounds.
cd ~/buster-fast-bench/2924-linker
d=$(mktemp -d /tmp/2924-linker-ab.XXXXXX)
for round in $(seq 1 $3); do
  echo "== round $round main"; taskset -c 2 src/build/compiler benchmark-executable --directory $d --functions "$2" --only "$1" --exact
  echo "== round $round exp"; taskset -c 2 hexe/build/compiler benchmark-executable --directory $d --functions "$2" --only "$1"
done
rm -rf $d
