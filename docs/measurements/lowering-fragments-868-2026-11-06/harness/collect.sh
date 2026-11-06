#!/bin/bash
# #868: one TSV line per round, offset, variant and input: the medians measure-compile reported for lower,
# lower.statements, the stages' span and the default runs' wall time (ms), and the batched count. Lua's line sums its
# units' medians.
D=$HOME/buster-fast-bench/868-claude
printf 'round\toffset\tvariant\tinput\tlower\tstatements\tspan\twall\tbatched\tevaluated\n'
for dir in "$D"/results/round-*; do
    round=${dir##*-}
    for off in 0 2048; do
        for v in off on; do
            for input in sqlite lua; do
                if [ "$input" = sqlite ]; then files=("$dir/sqlite-$off-$v.txt"); else files=("$dir"/lua-*-"$off-$v".txt); fi
                awk -v r="$round" -v o="$off" -v v="$v" -v in_="$input" '
                    $1 == "lower" { lower += $2 }
                    $1 == "lower.statements" { st += $2 }
                    $1 == "span" { span += $2 }
                    $1 == "default:" { wall += $5 }
                    /^lowering coverage/ { for (i = 1; i <= NF; i++) { if ($i ~ /^batched=/) { split($i, a, "="); b += a[2] } if ($i ~ /^evaluated=/) { split($i, a, "="); e += a[2] } } }
                    /measure-compile: [1-9][0-9]* failures/ { failed = 1 }
                    END { if (failed) print "FAILED " FILENAME > "/dev/stderr"; printf "%s\t%s\t%s\t%s\t%.3f\t%.3f\t%.3f\t%.3f\t%d\t%d\n", r, o, v, in_, lower, st, span, wall, b, e }
                ' "${files[@]}"
            done
        done
    done
done
