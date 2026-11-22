#!/bin/bash
# inputs2.sh: the shapes main's benchmark lacks (#3044's lengths, suffix, repeats and tie) at 4,096 and 131,072
# literals, kept, made by the branch's Release executable (run under the 9700X's lock).
set -eu
D=~/buster-fast-bench/3044-claude
mkdir -p $D/inputs/bench2
for s in lengths suffix repeats tie; do
    taskset -c 2 $D/old/build/compiler benchmark-foreign-strings --keep --runs 1 --counts 4096,131072 --only $s --directory $D/inputs/bench2 | grep -v '^foreign-strings .* runs 1:'
done
