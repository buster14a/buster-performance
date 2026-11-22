#!/bin/bash
# round.sh NAME ROUND EXE...: one round of #3261's merge-strings stage readings, run under the 9700X's lock by
# stage.sh. For each input (inputs.txt: a name and its link-foreign arguments a line) the executables run in an order
# shuffled by the round (seeded, recorded), each one `link-foreign --merge-strings --time --lanes 1` pinned to CPU 2;
# each line of results/NAME.tsv is round, input, executable, position and the stage's milliseconds.
set -u
D=~/buster-fast-bench/3044-claude
name=$1; round=$2; shift 2
exes=("$@")
out=$D/results/$name.tsv
echo "# round $round $(date -u +%FT%TZ) load $(cat /proc/loadavg)" >> $D/results/$name.ps
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 >> $D/results/$name.ps
while read -r input args; do
    [ -z "$input" ] && continue
    order=$(printf '%s\n' "${!exes[@]}" | shuf --random-source=<(openssl enc -aes-256-ctr -pass pass:"$round-$input" -nosalt < /dev/zero 2> /dev/null))
    position=0
    for i in $order; do
        exe=${exes[$i]}
        ms=$(cd $D/inputs && taskset -c 2 $exe link-foreign --merge-strings --time --lanes 1 -o $D/out/$i $args 2>&1 | awk '$1 == "merge-strings" {print $2}')
        echo -e "$round\t$input\t$(basename $exe)\t$position\t${ms:-fail}" >> $out
        position=$((position + 1))
    done
done < $D/inputs.txt
echo "# round $round end $(date -u +%FT%TZ) load $(cat /proc/loadavg)" >> $D/results/$name.ps
