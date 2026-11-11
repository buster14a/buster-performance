#!/bin/sh
# #1444: waits (waits.c) on base's and head's placement-0 executables, the parent asleep in wait4 or spinning, 400
# processes of each in each mode per input; then each build's in-process time (--time-stages' total, from the setup's
# start to the release's end), 200 processes each, alternated. One hold of the 9700X's lock.
#   waits.sh TAG
set -e
d=~/buster-fast-bench/1444-claude-lanes
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
clang -O2 -Wall -Wextra -o $d/waits $d/waits.c
cat > $d/waits-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-lanes
tag=$1
A=$d/shifts-base/compiler-0
B=$d/shifts-head/compiler-0
for case in empty tiny two hello; do
    case $case in
        empty) set -- -fsyntax-only empty.c ;;
        tiny) set -- -c tiny.c -o /dev/null ;;
        two) set -- -c two.c -o /dev/null ;;
        hello) set -- -c hello.c -o /dev/null ;;
    esac
    echo "== $case: $*"
    $d/waits 200 $A $B -- "$@"
    for build in base head; do : > $d/results/total-$build-$case-$tag.txt; done
    i=0
    while [ $i -lt 200 ]; do
        for build in base head; do
            $d/shifts-$build/compiler-0 --time-stages "$@" 2>&1 >/dev/null | awk '$1 == "time-stage" && $2 == "total" { print $3 }' >> $d/results/total-$build-$case-$tag.txt
        done
        i=$((i + 1))
    done
    for build in base head; do
        sort -n $d/results/total-$build-$case-$tag.txt | awk -v b=$build '{ v[NR] = $1 } END { printf "in-process total %s: %d runs, median %.3f ms, quartiles %.3f to %.3f ms\n", b, NR, v[int((NR + 1) / 2)], v[int(NR / 4) + 1], v[int(3 * NR / 4)] }'
    done
done
INNER
chmod +x $d/waits-inner.sh
~/buster-fast-bench/exclusive.sh $d/waits-inner.sh $tag > $d/results/waits-$tag.txt 2>&1
echo done > $d/results/waits-$tag.done
