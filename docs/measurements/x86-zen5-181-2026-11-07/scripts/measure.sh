#!/bin/bash
# One measure-x86-zen5 process on the 9700X under the shared lock, pinned to CPU 2 (#181): measure.sh NAME ARGUMENT...
cd ~/buster-fast-bench/181-claude/src || exit 1
export EXCLUSIVE_OWNER=claude-181 EXCLUSIVE_TITLE="Solve 181: Zen 5 model" EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQsfeQGFgj9Zjd9KtQ8
name="$1"
shift
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-x86-zen5 "$@" > "../measure-$name.tsv" 2> "../measure-$name.err"
echo "exit $?" >> "../measure-$name.err"
