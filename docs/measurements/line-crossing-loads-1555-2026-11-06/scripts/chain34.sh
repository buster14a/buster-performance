#!/bin/bash
# After stage2 builds the lexer executables: stage3 (whole driver), then stage4 (lexer variants), each its own hold.
cd ~/buster-fast-bench/1555-claude
until grep -q "^stage2-done" stage2.log; do sleep 10; done
export EXCLUSIVE_OWNER=claude-1555 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1555
EXCLUSIVE_TITLE="#1555 line-crossing loads (lexer whole driver)" ~/buster-fast-bench/exclusive.sh run/stage3.sh > run/stage3.log 2>&1
EXCLUSIVE_TITLE="#1555 line-crossing loads (lexer variants)" ~/buster-fast-bench/exclusive.sh ./stage4.sh > stage4.log 2>&1
