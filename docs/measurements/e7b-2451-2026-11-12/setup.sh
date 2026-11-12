#!/bin/bash
# e7b-claude: one tree per measured revision (setup.sh NAME BRANCH-OR-COMMIT).
set -e
D=~/buster-fast-bench/e7b-claude
mkdir -p $D && cd $D
[ -f sqlite3.c ] || cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c sqlite3.c
[ -d $1 ] || git clone -q https://github.com/buster14a/buster $1
git -C $1 fetch -q origin "$2" && git -C $1 checkout -q FETCH_HEAD
git -C $1 log -1 --format="$1 %H"
