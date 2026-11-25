#!/bin/bash
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: #3602's head against main, musl c99" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3602 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 5 main20f pr3599v2 > results/builds-c99-final.txt 2> results/builds-c99-final.err
echo done > results/job-c99-final.done
