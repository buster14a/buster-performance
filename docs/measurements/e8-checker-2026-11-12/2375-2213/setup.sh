#!/bin/bash
# e8-checker-claude: base (main 8c67a8d6) vs #2375's head (e8/2375-record-casts 8a94efbbaaac9e31dac440f9b48a18a00cf805ed) and #2213's head (e8/2213-elaborated-enum-base 97fa6447f7c93d58874a0753595e093cade73f49).
set -e
D=~/buster-fast-bench/2375-claude-e8
mkdir -p $D && cd $D
for t in base h2375 h2213; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
done
git -C base fetch -q origin main && git -C base checkout -q 8c67a8d6
git -C h2375 fetch -q origin e8/2375-record-casts && git -C h2375 checkout -q 8a94efbbaaac9e31dac440f9b48a18a00cf805ed
git -C h2213 fetch -q origin e8/2213-elaborated-enum-base && git -C h2213 checkout -q 97fa6447f7c93d58874a0753595e093cade73f49
cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c $D/sqlite3.c
for t in base h2375 h2213; do git -C $t log -1 --format="$t %H"; done
