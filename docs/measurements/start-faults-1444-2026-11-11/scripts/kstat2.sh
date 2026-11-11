#!/bin/sh
# #1444 items 1 and 2: user and kernel cycles, task clock and faults of each build at each of its four placements, and
# of base again (the floor), warm (perf stat -r: each process right after the last of the same executable), in rounds
# of a rotating build order. Pinned to CPU 2 but for the -lanes controls, which run on every CPU, so that a session
# starts its lanes (8 on the 9700X), whose threads each clear the executable's thread-local data. Each round is one
# hold of the 9700X's lock.
#   kstat2.sh TAG ROUNDS HEAD...
set -e
d=~/buster-fast-bench/1444-claude-arenas
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-arenas EXCLUSIVE_TITLE="Arenas' first commits and anonymous faults (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
rounds=$2
shift 2
builds="base $* base-again"
out=$d/results/kstat2-$tag
mkdir -p $out
cat > $out/round.sh <<'INNER'
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
INNER
chmod +x $out/round.sh
round=1
while [ $round -le $rounds ]; do
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
