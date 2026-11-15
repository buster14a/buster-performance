#!/bin/bash
# final.sh: the record's builds and runs. `base` is main 1b8231ea; `head` is it with facts-8.patch (the pull request's
# sources). Then, each run its own hold of the lock: the facts on the three corpora, three runs of each window setting
# (facts.sh by run-label.sh's three lines); the kernel's profile on sqlite3.c; and -c sqlite3.c whole, base against head.
cd "$(dirname "$0")"
./build-label.sh base 1b8231ea || exit 1
./build-label.sh head 1b8231ea facts-8.patch || exit 1
./facts.sh head "" 3 --passes 5 --list 20
./facts.sh head "-packed" 3 --facts-packed --passes 5 --list 20
./facts.sh head "-packed4096" 3 --facts-packed --facts-window 4096 --passes 5 --list 20
for e in "cycles 200003" "instructions 400009" "branch-misses 1009"; do
    set -- $e
    ./profile.sh head 40 $1 $2 --facts-packed > results/head/profile-summary-$1.txt 2>&1
done
./compile.sh base head 4
echo final-done
