#!/bin/bash
# split-time.sh TAG VARIANT UNIT [PARTS]: under one hold of the 9700X's lock, the split of UNIT's optimized bitcode in the
# VARIANT tree of $TREE (default src) into PARTS (8) code parts, timed (wall, user, system) with its --report, then
# again under perf record (call graphs, every child), into results/TAG/.
set -u
base=~/buster-fast-bench/2639-claude
tag=$1
variant=$2
unit=$3
parts=${4:-8}
out=$base/results/$tag
mkdir -p "$out"
tree=$base/${TREE:-src}/build/cmake/$variant
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export OUT="$out" TREE_DIR="$tree" UNIT="$unit" PARTS="$parts" SPLIT="${SPLIT:-$tree/codegen-tools/split}"
~/buster-fast-bench/exclusive.sh timeout -k 10 600 bash -c '
    input=$TREE_DIR/CMakeFiles/buster_$UNIT.dir/Release/src/buster/compiler/$UNIT.c.o
    scratch=$(mktemp -d /tmp/claude-2639-split.XXXXXX)
    TIMEFORMAT="wall %R user %U system %S"
    { time "$SPLIT" "$input" $PARTS "$scratch" --report 2> "$OUT/report.txt"; } 2> "$OUT/time.txt"
    ls -l "$scratch" > "$OUT/parts.txt"
    rm -rf "$scratch"; mkdir -p "$scratch"
    perf record -g -o "$OUT/perf.data" -- "$SPLIT" "$input" $PARTS "$scratch" 2> "$OUT/perf-record.txt"
    perf report -i "$OUT/perf.data" --no-children --sort comm,dso,symbol --percent-limit 0.5 --stdio 2> /dev/null | head -150 > "$OUT/perf-self.txt"
    perf report -i "$OUT/perf.data" --children --sort symbol --percent-limit 2 --stdio -g none 2> /dev/null | head -120 > "$OUT/perf-children.txt"
    rm -rf "$scratch"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
