#!/bin/bash
# The front prototype on several cores (front_par): 1, 2, 4 and 8 lanes on cores of their own with their threads made
# in each round, 8 lanes with threads kept between rounds (--warm), and 15 lanes on every thread of the machine; then
# the sequential build for reference, and 8 and 4 lanes once more. Each run under the lock by itself. The lanes pin
# themselves (--cpus), so no taskset here.
cd /tmp/2850-fermat
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
run() { name=$1; shift; env EXCLUSIVE_OWNER=claude-fermat-16yme8 EXCLUSIVE_TITLE="Direct path performance redesign: $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850 timeout -k 5 300 ~/buster-fast-bench/exclusive.sh "$@"; }
one() {
  lanes=$1; mode=$2
  case $lanes in 1) cpus=2;; 2) cpus=2,3;; 4) cpus=2,3,4,5;; 6) cpus=2,3,4,5,6,7;; 8) cpus=2,3,4,5,6,7,0,1;; 15) cpus=2,3,4,5,6,7,0,1,8,9,11,12,13,14,15;; esac
  flag=""; [ $mode = warm ] && flag="--warm"
  run "front prototype, $lanes lanes" ./front_par dump $S 51 $lanes --cpus $cpus $flag 2>&1 | grep -a -E "^rounds|^its parts|^the lanes|^pass A|SAME|DIFFERS|^source|^check|^front_par" | sed "s/^/lanes $lanes $mode: /" >> par.out
}
: > par.out
one 8 cold; one 1 cold; one 4 cold; one 2 cold; one 8 warm; one 15 cold
run "front prototype, one lane, the sequential build" taskset -c 2 ./front-v4 dump $S 51 2>&1 | grep -a -E "^rounds|^pass A alone|SAME|DIFFERS" | sed "s/^/sequential: /" >> par.out
one 8 cold; one 4 cold; one 6 cold
touch par.done
