#!/bin/bash
# profs.sh TAG: perf profiles of five -c -g sqlite3.c (and five without -g) by both trees, each under its own hold.
d=~/buster-fast-bench/2542-claude
export EXCLUSIVE_OWNER=claude-2542 EXCLUSIVE_TITLE="buster #2542: -g's DWARF values written once" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2542
x=~/buster-fast-bench/exclusive.sh
$x timeout -k 5 600 $d/prof.sh $d/src $1-main-prof
$x timeout -k 5 600 $d/prof.sh $d/new $1-new-prof
echo done-profs
