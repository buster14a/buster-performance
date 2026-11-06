#!/usr/bin/env bash
# #1340: the four builds' sq-c with -Wall -Wextra (every common warning enabled), 11 rotated rounds with
# --time-stages, CPU 2, one hold; then uarch's summary and stage medians.
set -u
cd ~/buster-fast-bench/1340-droid/root || exit 2
echo $$ > ../wx.pid
SCRATCH=scratch/zen5-9700x
source ../repo/tools/microarch/workloads.sh
B="pre1049-znver5 main-znver5 walks-znver5 znver5"
args=()
for v in $B; do
    workload "$v" sq-c
    args+=(--list "$v:sq-c-wall-wextra" "${WL[@]}" -Wall -Wextra --time-stages)
done
mkdir -p ../wx
status=0
EXCLUSIVE_OWNER=droid-1340 EXCLUSIVE_TITLE="droid #1340 common warnings cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
    ~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> ../wx/holds.txt; LC_ALL=C taskset -c 2 ./uarch time ../wx/ab-wx 11 "$@"' _ "${args[@]}" || status=1
./uarch summarize ../wx/ab-wx || status=1
for v in $B; do
    ./uarch stages ../wx/ab-wx/logs/"$v":sq-c-wall-wextra.r*.log > ../wx/stages-$v.tsv || status=1
done
echo "done status=$status" >> ../wx.done
