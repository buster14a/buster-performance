#!/bin/bash
# #3335: VMOVHPS_X_X_M64's Zen 5 rows, measured by measure-x86-zen5 --missing --table at the branch's head.
D=/tmp/3335-claude
cd $D
export EXCLUSIVE_OWNER=claude-3335 EXCLUSIVE_TITLE="buster #3335 Tier 0 vzeroupper" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3335
snap() { echo "== $1 $(date -u +%FT%TZ) loadavg $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; }
export -f snap
while pgrep -f "[r]un2.sh" > /dev/null; do sleep 10; done
(cd mine && git fetch -q origin claude/3335-tier0-vzeroupper && git checkout -q FETCH_HEAD && git log --oneline -1 && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release 2>&1 | tail -1)
~/buster-fast-bench/exclusive.sh bash -c 'snap before; cd mine && taskset -c 2 timeout -k 5 1200 ./build/compiler measure-x86-zen5 --missing --table > ../results/zen5-missing.txt 2> ../results/zen5-missing.err; echo exit $?; cd ..; snap after' > results/zen5.log 2>&1
echo RUN3 DONE
