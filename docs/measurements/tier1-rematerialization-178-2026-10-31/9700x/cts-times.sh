#!/usr/bin/env bash
# cts-times.sh TREE ROUNDS: c-testsuite's subset built by TREE's --tier1 with and without rematerialization (#178), one
# hold of the shared lock for the builds (with -lm, as the harness links them); the programs whose executables differ, timed in one hold: ROUNDS rounds of
# every such program both ways, in an order that rotates by round, each run pinned to CPU 2; then each mode's median
# per program and the sum of the medians.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-178-remat || exit 1
tree=$1
rounds=$2
CTS=$HOME/buster-fast-bench/claude-435/c-testsuite
out=$PWD/cts-$tree
export EXCLUSIVE_OWNER=claude-178-remat
export EXCLUSIVE_TITLE="Tier 1 rematerialization in linear scan (#178): c-testsuite's programs"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/178
lock=~/buster-fast-bench/exclusive.sh
rm -rf $out && mkdir -p $out
"$lock" bash -c "for t in \$(grep -E '^[0-9]+\$' $tree/tests/c-testsuite/subset.txt); do
    $tree/build/compiler --tier1 -fno-asynchronous-unwind-tables -o $out/\$t-remat $CTS/tests/single-exec/\$t.c -lm > /dev/null 2>&1 || echo \"\$t remat failed\"
    $tree/build/compiler --tier1 --tier1-no-rematerialize -fno-asynchronous-unwind-tables -o $out/\$t-noremat $CTS/tests/single-exec/\$t.c -lm > /dev/null 2>&1 || echo \"\$t noremat failed\"
    cmp -s $out/\$t-remat $out/\$t-noremat || echo \$t >> $out/differ.txt
done"
touch $out/differ.txt
echo "programs whose executables differ: $(wc -l < $out/differ.txt) of $(grep -cE '^[0-9]+$' $tree/tests/c-testsuite/subset.txt)"
"$lock" bash -c "cd $out && for r in \$(seq 0 $((rounds - 1))); do
    for t in \$(cat differ.txt); do
        for m in \$( [ \$((r % 2)) = 0 ] && echo remat noremat || echo noremat remat ); do
            s=\$EPOCHREALTIME; taskset -c 2 ./\$t-\$m > /dev/null 2>&1; e=\$EPOCHREALTIME
            echo \"\$t \$m \$(( \${e/./} - \${s/./} ))\" >> times.txt
        done
    done
done"
for m in remat noremat; do
    awk -v m=$m '$2 == m {print $1, $3}' $out/times.txt | sort -k1,1 -k2,2n | awk '{a[$1] = a[$1] " " $2; n[$1] += 1} END {for (t in a) {split(substr(a[t], 2), v, " "); print t, v[int((n[t] + 1) / 2)]}}' | sort > $out/medians-$m.txt
    echo "$m: sum of medians $(awk '{s += $2} END {print s}' $out/medians-$m.txt) us over $(wc -l < $out/medians-$m.txt) programs"
done
join $out/medians-remat.txt $out/medians-noremat.txt > $out/medians.txt
