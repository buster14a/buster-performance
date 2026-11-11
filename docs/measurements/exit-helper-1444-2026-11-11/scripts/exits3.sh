#!/bin/sh
# #1444: phases (phases.c) on exits.c's processes: none against a private futex hash replaced (q), allocated at 32 slots
# (r), and replaced after a joined thread (s); and against 5 parked threads again; each touching 64 MB, 200 processes
# of each. One hold.
#   exits3.sh TAG
d=~/buster-fast-bench/1444-claude-lanes
cd $d
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Move a single-threaded compile's teardown off its exit (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2075
tag=$1
clang -O2 -Wall -Wextra -pthread -o $d/exits-0 $d/exits.c
for m in 5 q r s; do ln -f $d/exits-0 $d/exits-$m; done
cat > $d/exits3-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-lanes
for m in q r s 5; do
    echo "== exits-0 against exits-$m, 64 MB"
    $d/phases 100 $d/exits-0 $d/exits-$m -- 64 | grep -E "exits|report to end|failed"
done
INNER
chmod +x $d/exits3-inner.sh
~/buster-fast-bench/exclusive.sh $d/exits3-inner.sh > $d/results/exits-$tag.txt 2>&1
echo done > $d/results/exits-$tag.done
