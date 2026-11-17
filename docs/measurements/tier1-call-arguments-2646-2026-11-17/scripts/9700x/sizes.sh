#!/usr/bin/env bash
# 2646 sizes: each revision's Zen 5 compiler (compilers.sh) compares sqlite3.c's and Lua's Tier 1 function bytes with
# clang -O0's (measure-tier1-programs --sizes-only --check-code-size), one hold of the lock per revision.
set -u
W=$HOME/buster-fast-bench/2646-claude
export EXCLUSIVE_OWNER=claude-2646 EXCLUSIVE_TITLE="Tier 1 code size: call arguments in their registers (#2646)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2918
L=$HOME/buster-fast-bench/exclusive.sh
mkdir -p $W/sizes
unset CPATH C_INCLUDE_PATH
for t in base head; do
    $L bash -c "clang --version | head -1; $W/$t/build/compiler measure-tier1-programs --sizes-only --check-code-size --clang clang --sqlite $W/inputs/sqlite --lua $W/inputs/lua/lua-5.4.8/src --directory /tmp" > $W/sizes/$t.txt 2>&1
    echo "$t exit $?" >> $W/sizes/log.txt
done
exit 0
