#!/bin/bash
# e7-claude: base (main 8c67a8d6) vs #2217, #2218 and #2409's -Wunused-but-set-variable heads.
set -e
D=~/buster-fast-bench/e7-claude
mkdir -p $D && cd $D
for t in base h2217 h2218 h2409u; do [ -d $t ] || git clone -q https://github.com/buster14a/buster $t; done
git -C base checkout -q 8c67a8d6
git -C h2217 fetch -q origin e7/2217-integer-overflow && git -C h2217 checkout -q f0f2688264af0df1a4d56a6b8c9acb6ad802d97a
git -C h2218 fetch -q origin e7/2218-out-of-range && git -C h2218 checkout -q 8dedcbc1daef9716747576706046b0a76739d062
git -C h2409u fetch -q origin e7/2409-unused-but-set && git -C h2409u checkout -q dd7857b3af28344ba874e7e3ebe8bc898e4e3f3f
cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c $D/sqlite3.c
for t in base h2217 h2218 h2409u; do git -C $t log -1 --format="$t %H"; done
