#!/bin/sh
# benchmark-bind, main (68cc356a4, src/) and head (hbind/, claude/2924-linker-2), alternating processes, CPU 2. $1: --functions, $2: rounds.
cd ~/buster-fast-bench/2924-linker
for round in $(seq 1 $2); do
  echo "== round $round main"; taskset -c 2 src/build/compiler benchmark-bind --functions "$1"
  echo "== round $round exp"; taskset -c 2 hbind/build/compiler benchmark-bind --functions "$1"
done
