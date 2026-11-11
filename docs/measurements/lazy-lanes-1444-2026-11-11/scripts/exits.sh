#!/bin/sh
# #1444: phases (phases.c) on exits.c's processes: none against 1 to 7 parked threads, one joined, and none with a private
# futex hash of 16 slots, each touching 64 MB, 200 processes of each. One hold.
#   exits.sh TAG
d=~/buster-fast-bench/1444-claude-lanes
cd $d
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
clang -O2 -Wall -Wextra -pthread -o $d/exits-0 $d/exits.c
for m in 1 2 3 4 5 6 7 j p; do ln -f $d/exits-0 $d/exits-$m; done
cat > $d/exits-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-lanes
for m in 1 2 3 4 5 6 7 j p; do
    echo "== exits-0 against exits-$m, 64 MB"
    $d/phases 100 $d/exits-0 $d/exits-$m -- 64 | grep -E "exits|report to end"
done
INNER
chmod +x $d/exits-inner.sh
~/buster-fast-bench/exclusive.sh $d/exits-inner.sh > $d/results/exits-$tag.txt 2>&1
echo done > $d/results/exits-$tag.done
