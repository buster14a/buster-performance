#!/usr/bin/env bash
set -u
. "$HOME/buster-fast-bench/2270-claude/env.sh"
cd $W
until grep -q "campaign done" campaign.out; do sleep 30; done
rm -f off.tsv
for rs in "1 2 3" "4 5 6"; do $L bash -c "for r in $rs; do ./offstat.sh off.tsv \$r; done"; done
echo campaign2 done
