#!/bin/bash
# calibrate.sh COMPILER PREDEFINES FLAGS_FILE FILE... : per file, its parser tokens and the peak RSS a -c --lanes 1 adds.
compiler=$1; predefines=$2; flags_file=$3; shift 3
read -r -a flags < "$flags_file"
out=$(mktemp -d ~/.cache/claude-1109/cal.XXXXXX)
for f in "$@"; do
    tokens=$(nice -n 19 "$compiler" benchmark-parser --passes 1 --only stages "${flags[@]}" --predefines "$predefines" "$f" 2>&1 | sed -n '1s/.*: \([0-9]*\) tokens.*/\1/p')
    nice -n 19 "$compiler" --time-stages --lanes 1 "${flags[@]}" -c -o "$out/o.o" "$f" 2> "$out/err" > /dev/null
    status=$?
    peak=$(sed -n 's/^time-process\tpeak-rss-kb\t//p' "$out/err")
    start=$(sed -n 's/^time-process\tpeak-rss-start-kb\t//p' "$out/err")
    total=$(sed -n 's/^time-stage\ttotal\t\([0-9.]*\).*/\1/p' "$out/err")
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$f" "$status" "$tokens" "$peak" "$start" "$total"
done
rm -rf "$out"
