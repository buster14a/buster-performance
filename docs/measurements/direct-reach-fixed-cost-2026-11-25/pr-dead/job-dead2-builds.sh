#!/bin/bash
# #3592's step 6d's final head (dead2) against step 6c's head: musl's builds in both modes and Lua's.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: dead arms (#3592 step 6d), builds" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 7 atom1 dead2 > results/builds-c99-dead2.txt 2> results/builds-c99-dead2.err
X timeout -k 5 900 env BUILDS="lua musl" ./builds-ab.sh 7 atom1 dead2 > results/builds-gnu-dead2.txt 2> results/builds-gnu-dead2.err
echo done > results/job-dead2-builds.done
