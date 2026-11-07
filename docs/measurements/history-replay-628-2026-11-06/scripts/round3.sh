#!/bin/bash
# round3.sh MAIN HEAD: moves main/ to MAIN and branch/ to HEAD, builds each under its own hold of the lock (build.sh).
set -u
cd ~/buster-fast-bench/628-claude-tesla
git -C main fetch -q origin main && git -C main checkout -q "$1"
git -C branch fetch -q origin claude/practical-tesla-2lgodi && git -C branch checkout -q "$2"
git -C main log -1 --format='main %H'; git -C branch log -1 --format='branch %H'
./build.sh main
./build.sh branch
echo round3-built
