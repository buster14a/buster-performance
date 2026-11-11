#!/bin/bash
# Peak RSS of base and head on -fsyntax-only sqlite3.c with base pages (BUSTER_HUGE_PAGES=0).
D=~/buster-fast-bench/1969-claude
cd $D
BUSTER_HUGE_PAGES=0 taskset -c 2 base/build/compiler time-runs --runs 3 --warmups 1 --build base $D/base/build/compiler --build head $D/head/build/compiler \
  --list -fsyntax-only $D/sqlite3.c 2>&1 | grep "^list 1 "
