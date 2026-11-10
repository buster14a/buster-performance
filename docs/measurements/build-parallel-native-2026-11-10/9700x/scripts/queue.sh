#!/bin/bash
# PR #2056 build-time A/B on the 9700X: each build is its own exclusive.sh hold.
d=$HOME/buster-fast-bench/2056-claude
cd "$d" || exit 2
echo $$ > queue.pid
mkdir -p logs
export EXCLUSIVE_OWNER=claude-pr2056-review EXCLUSIVE_TITLE="Review PR 2056 build-time A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2056
B=base-39506e86; H=head-fa6254e0
one() { ~/buster-fast-bench/exclusive.sh "$d/run1.sh" "$@"; }
one $B warm - 0; one $H warm - 0
for rep in 1 2 3; do
    if [ $((rep % 2)) = 1 ]; then one $B fresh - $rep; one $H fresh - $rep; else one $H fresh - $rep; one $B fresh - $rep; fi
done
cases="main:main.c:main.c pp:c_preprocessor.c:c_preprocessor_impl.c exe:executable.c:executable_impl.c input:c_check_input.c:c_check_input.c dataflow:ir_dataflow.c:ir_dataflow.c tier0:tier0.c:tier0.c"
for rep in 1 2 3; do
    for c in $cases; do
        IFS=: read -r name bf hf <<< "$c"
        if [ $((rep % 2)) = 1 ]; then one $B $name $bf $rep; one $H $name $hf $rep; else one $H $name $hf $rep; one $B $name $bf $rep; fi
    done
done
sha256sum $B/build/compiler $H/build/compiler > sha.txt
echo done >> results.txt
