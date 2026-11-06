#!/usr/bin/env bash
# #1340: head's sq-syn with and without -Wno-empty-body (sqlite3.c's one default warning, #1339's), 11 rotated
# rounds with --time-stages, CPU 2, one hold: what placing that one diagnostic costs.
set -u
cd ~/buster-fast-bench/1340-droid/root || exit 2
SCRATCH=scratch/zen5-9700x
source ../repo/tools/microarch/workloads.sh
workload znver5 sq-syn
args=(--list "znver5:sq-syn" "${WL[@]}" --time-stages --list "znver5:sq-syn-no-empty-body" "${WL[@]}" -Wno-empty-body --time-stages)
mkdir -p ../ep
status=0
EXCLUSIVE_OWNER=droid-1340 EXCLUSIVE_TITLE="droid #1340 common warnings cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
    ~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> ../ep/holds.txt; LC_ALL=C taskset -c 2 ./uarch time ../ep/ab-ep 11 "$@"' _ "${args[@]}" || status=1
./uarch summarize ../ep/ab-ep || status=1
./uarch stages ../ep/ab-ep/logs/znver5:sq-syn.r*.log > ../ep/stages-znver5.tsv || status=1
./uarch stages ../ep/ab-ep/logs/znver5:sq-syn-no-empty-body.r*.log > ../ep/stages-znver5-no-empty-body.tsv || status=1
echo "done status=$status" >> ../ep.done
