#!/usr/bin/env bash
# bounds.sh: the review's tree at bounds 4, 8 and 16 (BUSTER_TIER1_BURS_BOUND), each built and its tables' summary printed.
. ~/buster-fast-bench/claude-141-takeover/common.sh
for b in 8 4 16; do
    t=t-bound$b
    rm -rf $t && git clone -q --no-checkout h-153497c4 $t && git -C $t checkout -q 38881f57 2>/dev/null || { git -C $t fetch -q https://github.com/buster14a/buster claude/issue-141-resolution-2goqwz && git -C $t checkout -q 38881f57; }
    git -C $t apply --whitespace=nowarn ../review.patch
    [ $b != 8 ] && cp burs-bound$b.c $t/src/buster/compiler/tier1_select_burs.c
    ./build.sh $t
    "$lock" bash -c "cd $t && ./build/compiler test-tier1-select 2>&1 | grep -E 'bottom-up rewrite:|selection:'" > bound$b.txt
done
echo done > bounds.done
