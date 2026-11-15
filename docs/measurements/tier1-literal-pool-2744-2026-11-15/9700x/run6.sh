#!/usr/bin/env bash
# buster#2744: the head's idle time in ab-lexer.log is the object writer's ftruncate of the shared output file on btrfs
# (head's object is 807 KB, main's 862 KB: a head run after a base run shrinks it). The same A/B with the output on
# tmpfs, after run5.sh.
set -uo pipefail
D=$HOME/buster-fast-bench/2744-claude
export EXCLUSIVE_OWNER=claude-2744
export EXCLUSIVE_TITLE="GitHub issue #2744 (Tier 1 literal pool)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2794
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D" || exit 1
echo $$ > run6.pid
log() { echo "$(date -u +%FT%TZ) $*" >> "$D/run6.log"; }
while [ ! -f run5.done ] && systemctl --user is-active -q claude-2744-r5; do sleep 20; done
log start
mkdir -p /tmp/claude-2744
B="--build base $D/results/compiler-base --build head $D/results/compiler-head4 --build base-again $D/results/compiler-base"
LEXER="--tier1 -fno-asynchronous-unwind-tables -march=znver5 -I$D/head/src -fwrapv -funsigned-char -fno-strict-aliasing -c $D/head/src/buster/compiler/c_lexer_benchmark.c -o /tmp/claude-2744/out-lexer.o"
results/compiler-head4 ab --rounds 2 --cpu 2 --lock "$X" "$D/results/compiler-head4" -- time-runs --runs 3 --copies 3 $B --list $LEXER > results/ab-lexer-head4-tmpfs.log 2>&1
log "ab lexer head4 tmpfs status $?"
rm -rf /tmp/claude-2744
log done
touch run6.done
