#!/bin/bash
# beside-run.sh COMPILER OUT: measure-node-machine --shadow --front-alone --bodies on the four corpora (bodies-before.sh), plain
# with the default warnings, with -Wall -Wextra and with -g, and read as -c reads a unit (bodies-controls.sh, --statement-controls)
# with the default warnings and with -Wall -Wextra; each run's sums (beside-reduce.py) in OUT/reduced.txt.
cc=$1; out=$2
b=$(dirname "$0")
mkdir -p "$out"
: > "$out/reduced.txt"
for mode in plain controls; do
    script=$b/bodies-before.sh
    [[ $mode == controls ]] && script=$b/bodies-controls.sh
    for flags in default wall g; do
        extra=()
        [[ $flags == wall ]] && extra=(-Wall -Wextra)
        [[ $flags == g ]] && extra=(-g)
        [[ $flags == g && $mode == controls ]] && continue
        echo "== $mode $flags" >> "$out/reduced.txt"
        bash "$script" "$cc" "$out/$mode-$flags" "${extra[@]}" 2>&1 | grep " exit " >> "$out/reduced.txt"
        python3 "$b/beside-reduce.py" "$out/$mode-$flags"/{sqlite,lua,main,musl}.txt >> "$out/reduced.txt"
    done
done
echo done >> "$out/reduced.txt"
