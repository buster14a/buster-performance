#!/bin/bash
# time-runs base vs head, one locked call per configuration.
set -u
W=$1
export EXCLUSIVE_OWNER=claude-c7 EXCLUSIVE_TITLE="C7: base vs head time-runs ($W)" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndwStrcg6Uz6tbXGb1
SQL=~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c
cd ~/buster-fast-bench/$W
for cfg in "-fsyntax-only $SQL" "-fsyntax-only -Wall $SQL" "-c -o /dev/null $SQL"; do
  echo "=== $cfg" >> times.txt
  ~/buster-fast-bench/exclusive.sh $PWD/head/build/compiler time-runs --runs 11 --build base $PWD/base/build/compiler --build head $PWD/head/build/compiler --list $cfg >> times.txt 2>&1
done
echo done >> times.txt
