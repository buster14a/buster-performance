#!/bin/bash
# ctime.sh: user+sys seconds of `--tier1 -c sqlite3.c --lanes 1` per variant, interleaved rounds.
S=/tmp/claude-0/-home-user/98d46d8d-c801-5eaa-b4aa-aa7221f6e075/scratchpad
C=$S/compiler-exp10
cd /home/user/inputs
for round in 1 2 3 4 5; do
  for v in base licm gvn both; do
    case $v in
      base) env=""; opt="";;
      licm) env="LICM_POLICY=46"; opt="--tier1-passes=+licm";;
      gvn) env="GVN_AFTER=1 GVN_POLICY=72"; opt="--tier1-passes=+gvn";;
      both) env="LICM_POLICY=46 GVN_AFTER=1 GVN_POLICY=72"; opt="--tier1-passes=+licm,+gvn";;
    esac
    t=$( { /usr/bin/env $env bash -c "TIMEFORMAT='%U %S'; time $C --tier1 --lanes 1 $opt -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c -o $S/sq-$v.o sqlite/sqlite3.c" ; } 2>&1 | tail -1)
    echo "$v $t"
  done
done
