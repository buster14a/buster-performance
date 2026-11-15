#!/usr/bin/env bash
# chain3.sh: after chain2.sh's profile of 23d0c3c (kept in profile-23d0c3c), head at 6f31185: rehead.sh, profile.sh,
# objects.sh, compile.sh, link.sh, time2.sh and the analysis in turn.
W=$HOME/buster-fast-bench/2774-claude
cd $W || exit 1
until grep -q 'profile.sh done' chain.log; do sleep 5; done
systemctl --user stop claude-2774b
echo "$(date -u +%FT%TZ) chain2 stopped after its profile" >> chain.log
step() { echo "$(date -u +%FT%TZ) $1 start" >> chain.log; ./$1 && echo "$(date -u +%FT%TZ) $1 done" >> chain.log || { echo "$(date -u +%FT%TZ) $1 FAILED" >> chain.log; exit 1; }; }
mv profile profile-23d0c3c
rm -rf obj-base obj-head exe
HEAD_SHA=6f31185156b30aeb82536e0fefa47962ac420fde step rehead.sh
step profile.sh
step objects.sh
step compile.sh
step link.sh
step time2.sh
cc -O2 -o analyze analyze.c -lm
./analyze < runs/runs.txt > analysis.txt 2>&1
echo "$(date -u +%FT%TZ) chain done" >> chain.log
