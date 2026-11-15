#!/bin/bash
# #2758 on the 9700X: base (main 2ebfe68) and head built Release, then 00040.c's typed form alone (interpret-c, one CPU),
# its four forms at once (test-ssa-source --typed, four CPUs) and CI's c-testsuite command (four CPUs), base and head
# alternating, three rounds, each run under its own hold of the lock with the busiest processes before and after.
set -uo pipefail
D=$HOME/buster-fast-bench/2758-claude
export EXCLUSIVE_OWNER=claude-2758
export EXCLUSIVE_TITLE="The interpreters' call path (#2758)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2758
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D"
echo $$ > bench.pid
rm -f bench.done
held()
{
    local label=$1
    shift
    "$X" bash -c 'label=$1; log=$2; shift 2; { echo "== $label before $(date -Is)"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$log"; "$@"; s=$?; { echo "== $label after $(date -Is) status $s"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$log"; exit $s' _ "$label" "$D/procs.log" "$@"
}
if [ ! -d c-testsuite ]; then
    git init -q --template= c-testsuite && git -C c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07 && git -C c-testsuite checkout -q FETCH_HEAD
fi
for t in base head; do
    if [ ! -x "compiler-$t" ]; then
        (cd "$t" && held "build-$t" timeout -k 10 2400 ./build.sh --config Release > "$D/build-$t.log" 2>&1) || { echo "build $t failed" > bench.done; exit 1; }
        cp "$t/build/compiler" "compiler-$t"
    fi
    test -x "compiler-$t" || { echo "no compiler-$t" > bench.done; exit 1; }
done
F=$D/c-testsuite/tests/single-exec/00040.c
subset=$(sed -n "s|^\([0-9][0-9]*\)\$|$D/c-testsuite/tests/single-exec/\1.c|p" base/tests/c-testsuite/subset.txt)
mkdir -p stats
for round in 1 2 3; do
    for t in base head; do
        held "typed-$t-$round" perf stat -e task-clock,cycles,instructions -o "stats/typed-$t-$round.txt" taskset -c 2 "$D/compiler-$t" interpret-c "$F" > "stats/typed-$t-$round.out" 2>&1
        echo "typed $t $round status $?" >> stats/status.txt
        held "forms-$t-$round" perf stat -e task-clock,cycles,instructions -o "stats/forms-$t-$round.txt" taskset -c 2-5 "$D/compiler-$t" test-ssa-source --typed "$F" > "stats/forms-$t-$round.out" 2>&1
        echo "forms $t $round status $?" >> stats/status.txt
        held "subset-$t-$round" perf stat -e task-clock -o "stats/subset-$t-$round.txt" taskset -c 2-5 "$D/compiler-$t" test-ssa-source --typed --tier1 $subset > "stats/subset-$t-$round.out" 2>&1
        echo "subset $t $round status $?" >> stats/status.txt
    done
done
echo done > bench.done
