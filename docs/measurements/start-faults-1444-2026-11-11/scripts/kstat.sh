#!/bin/sh
# #1444 items 1 and 2: user and kernel cycles, task clock and faults of each build's placement 0 and base's again (the
# floor), warm (perf stat -r: each process right after the last of the same build), pinned to CPU 2, ROUNDS rounds in
# a rotating build order. Each round is one hold of the 9700X's lock.
#   kstat.sh TAG ROUNDS HEAD...
set -e
d=~/buster-fast-bench/1444-claude-arenas
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-arenas EXCLUSIVE_TITLE="Arenas' first commits and anonymous faults (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
rounds=$2
shift 2
builds="base $* base-again"
out=$d/results/kstat-$tag
mkdir -p $out
cat > $out/round.sh <<'INNER'
#!/bin/sh
# One round: every build and control in this round's order.
d=~/buster-fast-bench/1444-claude-arenas
out=$1
round=$2
shift 2
for build in "$@"; do
    directory=$build
    [ $build = base-again ] && directory=base
    C=$d/shifts-$directory/compiler-0
    for control in syntax preprocess tiny hello medium; do
        case $control in
            syntax) set -- -fsyntax-only empty.c;;
            preprocess) set -- -E -P empty.c -o /dev/null;;
            tiny) set -- -c tiny.c -o /dev/null;;
            hello) set -- -c hello.c -o /dev/null;;
            medium) set -- -c medium.c -o /dev/null;;
        esac
        runs=300
        [ $control = medium ] && runs=50
        taskset -c 2 perf stat -r $runs -x, -e task-clock,page-faults,cycles:u,cycles:k,instructions:u,instructions:k -o $out/$build-$control-$round.csv $C "$@" > /dev/null 2>&1
    done
done
INNER
chmod +x $out/round.sh
round=1
while [ $round -le $rounds ]; do
    # Rotate the order: round r starts at build r.
    set -- $builds
    count=$#
    order=""
    i=0
    while [ $i -lt $count ]; do
        k=$(( (i + round - 1) % count + 1 ))
        eval "b=\${$k}"
        order="$order $b"
        i=$((i + 1))
    done
    ~/buster-fast-bench/exclusive.sh $out/round.sh $out $round $order
    round=$((round + 1))
done
echo done > $out/done
