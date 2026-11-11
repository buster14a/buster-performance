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
