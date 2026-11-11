#!/bin/sh
# One round: every build, placement and control in this round's order.
d=~/buster-fast-bench/1444-claude-arenas
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$1
round=$2
shift 2
for build in "$@"; do
    directory=$build
    [ $build = base-again ] && directory=base
    for shift in 0 1088 2112 3136; do
        C=$d/shifts-$directory/compiler-$shift
        for control in syntax preprocess tiny hello medium tiny-lanes sqlite-lanes; do
            pin="taskset -c 2"
            runs=200
            case $control in
                syntax) set -- -fsyntax-only empty.c;;
                preprocess) set -- -E -P empty.c -o /dev/null;;
                tiny) set -- -c tiny.c -o /dev/null;;
                hello) set -- -c hello.c -o /dev/null;;
                medium) set -- -c medium.c -o /dev/null; runs=40;;
                tiny-lanes) set -- -c tiny.c -o /dev/null; pin="";;
                sqlite-lanes) set -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o /dev/null; pin=""; runs=5;;
            esac
            $pin perf stat -r $runs -x, -e task-clock,page-faults,cycles:u,cycles:k,instructions:u,instructions:k -o $out/$build-$control-$shift-$round.csv $C "$@" > /dev/null 2>&1
        done
    done
done
