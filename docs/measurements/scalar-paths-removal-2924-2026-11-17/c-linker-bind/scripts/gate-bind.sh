#!/bin/sh
# benchmark-bind, both paths, at main (68cc356a4), pinned to CPU 2. $1: the --functions list.
cd ~/buster-fast-bench/2924-linker/src
taskset -c 2 ./build/compiler benchmark-bind --functions "$1"
