#!/bin/bash
# split-ab.sh TAG VARIANT UNIT: main's splitter (src's codegen-tools/split) against the branch's (split's), both as the
# builds made them, on main's bitcode of UNIT in VARIANT: in one hold of the 9700X's lock per round, each run into a
# scratch directory, timed, alternating, three rounds; then their parts compared byte for byte (the branch's without
# options writes Release's plan, so the same parts), and the branch's with a sanitizer build's options timed too.
set -u
base=~/buster-fast-bench/2639-claude
tag=$1
variant=$2
unit=$3
out=$base/results/$tag
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export INPUT="$base/src/build/cmake/$variant/CMakeFiles/buster_$unit.dir/Release/src/buster/compiler/$unit.c.o" OUT="$out"
export OLD="$base/src/build/cmake/$variant/codegen-tools/split" NEW="$base/split/build/cmake/$variant/codegen-tools/split"
for round in 1 2 3; do
    ROUND=$round ~/buster-fast-bench/exclusive.sh timeout 300 bash -c '
        TIMEFORMAT="wall %R user %U system %S"
        for which in old new options; do
            exe=$OLD; options=""
            [ $which != old ] && exe=$NEW
            [ $which = options ] && options="--codegen-costs --padded-starts"
            scratch=/tmp/claude-2639-ab-$which; rm -rf $scratch; mkdir -p $scratch
            { time "$exe" "$INPUT" 8 $scratch --report $options 2> "$OUT/report-$which.txt"; } 2>> "$OUT/time-$which.txt"
        done
        for f in /tmp/claude-2639-ab-old/*; do cmp -s $f /tmp/claude-2639-ab-new/${f##*/} && echo "same ${f##*/}" || echo "DIFF ${f##*/}"; done > "$OUT/compare-$ROUND.txt"
        rm -rf /tmp/claude-2639-ab-old /tmp/claude-2639-ab-new /tmp/claude-2639-ab-options
    ' 2>> "$out/exclusive.stderr"
done
echo "done $?" >> "$out/exclusive.stderr"
