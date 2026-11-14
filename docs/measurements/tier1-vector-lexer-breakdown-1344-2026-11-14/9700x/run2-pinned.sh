#!/usr/bin/env bash
# buster#1344, PR #2742's later head (the quadword splats): the Tier 1 lexer by it, after run.sh's builds and runs.
set -uo pipefail
D=$HOME/buster-fast-bench/1344-claude
HEAD2=40060bef
export EXCLUSIVE_OWNER=claude-1344
export EXCLUSIVE_TITLE="Buster compiler vector performance (#1344)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2742
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D" || exit 1
log() { echo "$(date -u +%FT%TZ) $*" >> "$D/run.log"; }
while systemctl --user is-active -q claude-1344; do sleep 5; done
log "run2 start"
FULL=6c28f8a78f16d5ede7c2c7f10c7d65cb1608ce81
git -C repo fetch -q --depth 1 origin $FULL >> run.log 2>&1 || { log "fetch2 failed"; exit 1; }
[ -d head2 ] || git -C repo worktree add -q --detach "$D/head2" $FULL >> run.log 2>&1
log "head2 is $(git -C head2 rev-parse HEAD)"
if [ ! -x head2/build/compiler ]; then
    (cd head2 && timeout 2400 "$X" ./build.sh --config Release > "$D/build-head2.log" 2>&1)
    log "build head2 status $? $(tail -1 build-head2.log)"
fi
[ -x head2/build/compiler ] || { log "no head2 compiler"; exit 1; }
R=$(ls -d rows/measure-tier1-rows-* | head -1)
MARCH=$(cd head2 && ./build.sh print-host-flags --config Release 2>/dev/null | tr '\0' ' ')
log "host flags: $MARCH"
(cd head2 && timeout 900 "$X" ./build/compiler --tier1 -fno-asynchronous-unwind-tables -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -c -o "$D/lexer-head2.o" src/buster/compiler/c_lexer_benchmark.c > "$D/lexer-head2.report" 2>&1)
log "lexer head2 object status $?"
clang -o "$D/lexer-head2" "$D/$R/lexer-main.o" "$D/lexer-head2.o" >> run.log 2>&1
for input in mid src; do
    target=$D/mid.c; [ $input = src ] && target=$D/head/src
    for run in 1 2 3; do
        timeout 900 "$X" taskset -c 2 "$D/lexer-head2" $target > "$D/lexer-head2-$input-$run.log" 2>&1
        log "lexer-head2 $input $run status $? $(grep 'c_tokenize ' lexer-head2-$input-$run.log | tr -s ' ')"
    done
done
log "run2 done"
