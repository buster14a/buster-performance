#!/bin/bash
# job26.sh: does a leaf's cost follow where the stack falls? m14 and u3 in turn on sqlite3.c, a body a window, the
# whole kernel and the loads' (the lean leaves' loop), randomization off, the stack moved down by 0 to 3,840 bytes in
# steps of 256 (facts-pad.sh); then each pad's leaf and kernel figures in a table.
set -u
cd "$(dirname "$0")"
for pad in $(seq 0 256 3840); do
    for label in m14 u3; do
        ./facts-pad.sh $label body $pad --passes 5 --list 20
        ./facts-pad.sh $label loads $pad --facts-loads --passes 5 --list 20
    done
done
for t in body loads; do for l in m14 u3; do for pad in $(seq 0 256 3840); do f=results/$l/pad-$t-$pad.txt; printf "%-6s %-4s %5d  " $t $l $pad; grep -o "the kernel a taken leaf or lookup: cycles=[0-9.]*" $f | grep -o "[0-9.]*$" | tr "\n" " "; grep -o "TSC ticks ([0-9.]* cycles a tick): a leaf=[0-9.]* a lookup=[0-9.]*; a window.s second run: a leaf=[0-9.]* a lookup=[0-9.]*" $f | sed "s/TSC ticks (\([0-9.]*\) cycles a tick): a leaf=\([0-9.]*\) a lookup=\([0-9.]*\); a window.s second run: a leaf=\([0-9.]*\) a lookup=\([0-9.]*\)/tick \1 leaf \2 lookup \3 again \4 \5/"; done; done; done > results/facts-pad-m14-u3.txt
echo "job26 done $(date -u +%FT%TZ)" >> results/job26.log
