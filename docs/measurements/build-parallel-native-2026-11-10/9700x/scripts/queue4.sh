#!/bin/bash
# Parallel native generation with explicit-only dependencies (b9e947dd), 14 and 8 code parts, against #2056's
# fa6254e0 on the 9700X: each build its own hold.
d=$HOME/buster-fast-bench/2056-claude
cd "$d" || exit 2
echo $$ > queue4.pid
export EXCLUSIVE_OWNER=claude-pr2056-split EXCLUSIVE_TITLE="Parallel native generation A/B (explicit dependencies)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2058
H=head-fa6254e0; P=split4-b9e947dd; Q=split4p8-b9e947dd
one() { ~/buster-fast-bench/exclusive.sh "$d/run4.sh" "$@"; }
one $P warm - 0
one $Q warm - 0
for rep in 1 2 3; do
    case $rep in
    1) order="$H $P $Q" ;;
    2) order="$P $Q $H" ;;
    3) order="$Q $H $P" ;;
    esac
    for t in $order; do one $t fresh - $rep; done
done
for rep in 1 2 3; do
    for c in main:main.c input:c_check_input.c tier0:tier0.c; do
        IFS=: read -r name file <<< "$c"
        if [ $((rep % 2)) = 1 ]; then one $H $name $file $rep; one $P $name $file $rep; else one $P $name $file $rep; one $H $name $file $rep; fi
    done
done
for t in $H $P; do (cd $d/$t && git checkout -q -- src); done
echo done >> "$d/results4.txt"
