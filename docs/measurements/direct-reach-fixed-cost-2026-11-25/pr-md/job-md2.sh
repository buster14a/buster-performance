#!/bin/bash
# #3592's dependency files: md1 against #3607's head (asm6d) without -M, with two controls: md2 (md1 with the
# functions only -MD runs cold) and pad48 (asm6d with 48 bytes of nops before the lexer's code: a placement change
# alone). Each build and measurement under the lock on its own.
cd ~/buster-fast-bench/direct-designs-np4nn5
X() { EXCLUSIVE_OWNER=claude-direct-designs-np4nn5 EXCLUSIVE_TITLE="Direct path: -MD and its kin (#3592), controls" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592 ~/buster-fast-bench/exclusive.sh "$@"; }
X timeout -k 5 1200 ./build-variant.sh md2 md2.patch
X timeout -k 5 1200 ./build-variant.sh pad48 pad48.patch
for n in asm6d pad48 md1 md2; do ./bin/compiler-$n --version > /dev/null || { echo "compiler-$n doesn't run" > results/job-md2.done; exit 1; }; done
X timeout -k 5 900 env AB_UNITS="six hello sqlite" ./ab.sh 21 asm6d pad48 md1 md2 > results/ab-md2.txt 2> results/ab-md2.err
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl ./builds-ab.sh 7 asm6d pad48 md1 md2 > results/builds-c99-md2.txt 2> results/builds-c99-md2.err
X timeout -k 5 900 env BUILDS=lua ./builds-ab.sh 7 asm6d pad48 md1 md2 > results/builds-lua-md2.txt 2> results/builds-lua-md2.err
X timeout -k 5 900 env MUSL_STD=-std=c99 BUILDS=musl DEP_FLAGS=-MD ./builds-ab.sh 5 md1 md2 > results/builds-c99-md2-deps.txt 2> results/builds-c99-md2-deps.err
X timeout -k 5 900 env AB_UNITS="six sqlite" AB_FLAGS=-MD ./ab.sh 21 md1 md2 > results/ab-md2-deps.txt 2> results/ab-md2-deps.err
echo done > results/job-md2.done
