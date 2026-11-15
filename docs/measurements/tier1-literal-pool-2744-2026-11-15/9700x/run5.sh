#!/usr/bin/env bash
# buster#2744: the PR's head 2b3c5c4 (a window's body copies its literals only where it has some) against main 1935a91,
# after diag.sh: one round each of -c sqlite3.c by Tier 0 and of the lexer's unit by --tier1.
set -uo pipefail
D=$HOME/buster-fast-bench/2744-claude
HEAD4=2b3c5c45b0df5c28c10ceebf849c1584f1154faf
export EXCLUSIVE_OWNER=claude-2744
export EXCLUSIVE_TITLE="GitHub issue #2744 (Tier 1 literal pool)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2794
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D" || exit 1
echo $$ > run5.pid
log() { echo "$(date -u +%FT%TZ) $*" >> "$D/run5.log"; }
while [ ! -f diag.done ] && systemctl --user is-active -q claude-2744-diag; do sleep 20; done
log start
git -C repo fetch -q origin claude/amazing-bohr-n5rbeo >> run5.log 2>&1
[ -d head4 ] || git -C repo worktree add -q --detach "$D/head4" $HEAD4 >> run5.log 2>&1
log "head4 is $(git -C head4 rev-parse HEAD)"
if [ ! -x results/compiler-head4 ]; then
    (cd head4 && "$X" env BUSTER_DEBUG_INFO=0 timeout 3600 ./build.sh --config Release > "$D/build-head4.log" 2>&1)
    log "build head4 status $? $(tail -1 build-head4.log)"
    [ -x head4/build/compiler ] && cp head4/build/compiler results/compiler-head4
fi
[ -x results/compiler-head4 ] || { log "no head4 compiler"; exit 1; }
sha256sum results/compiler-head4 >> results/compilers.sha256
B="--build base $D/results/compiler-base --build head $D/results/compiler-head4 --build base-again $D/results/compiler-base"
LEXER="--tier1 -fno-asynchronous-unwind-tables -march=znver5 -I$D/head/src -fwrapv -funsigned-char -fno-strict-aliasing -c $D/head/src/buster/compiler/c_lexer_benchmark.c -o $D/out-lexer.o"
C=$D/corpus
SQLITE="--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include -c $C/sqlite/sqlite3.c -o $D/out-sqlite.o"
results/compiler-head4 ab --rounds 1 --cpu 2 --lock "$X" "$D/results/compiler-head4" -- time-runs --runs 3 --copies 3 $B --list $SQLITE > results/ab-sqlite-head4.log 2>&1
log "ab sqlite head4 status $?"
results/compiler-head4 ab --rounds 1 --cpu 2 --lock "$X" "$D/results/compiler-head4" -- time-runs --runs 3 --copies 3 $B --list $LEXER > results/ab-lexer-head4.log 2>&1
log "ab lexer head4 status $?"
rm -rf head4/build
log done
touch run5.done
