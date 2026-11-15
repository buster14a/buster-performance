#!/usr/bin/env bash
# buster#2744 step 2 (the literal pool): main 1935a91 against the branch's head on the 9700X. Every build and run takes
# the machine's lock by itself (exclusive.sh), one hold a run.
set -uo pipefail
D=$HOME/buster-fast-bench/2744-claude
BASE=1935a91fbd07b6fec0f6d651c9649bb7f9ef4d3a
HEAD=5e33fe81db6ca38fe2683208976177c7843dc342
export EXCLUSIVE_OWNER=claude-2744
export EXCLUSIVE_TITLE="GitHub issue #2744 (Tier 1 literal pool)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2744
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D" || exit 1
echo $$ > run.pid
log() { echo "$(date -u +%FT%TZ) $*" >> "$D/run.log"; }
log "start"
if [ ! -d repo/.git ]; then
    git init -q repo && git -C repo remote add origin https://github.com/buster14a/buster
fi
git -C repo fetch -q origin $BASE claude/amazing-bohr-n5rbeo >> run.log 2>&1 || { log "fetch failed"; exit 1; }
[ -d base ] || git -C repo worktree add -q --detach "$D/base" $BASE >> run.log 2>&1
[ -d head ] || git -C repo worktree add -q --detach "$D/head" $HEAD >> run.log 2>&1
log "base $(git -C base rev-parse HEAD) head $(git -C head rev-parse HEAD)"
mkdir -p results
for side in base head; do
    if [ ! -x results/compiler-$side ]; then
        log "build $side"
        (cd $side && timeout 3600 env BUSTER_DEBUG_INFO=0 "$X" ./build.sh --config Release > "$D/build-$side.log" 2>&1)
        log "build $side status $? $(tail -1 build-$side.log)"
        [ -x $side/build/compiler ] && cp $side/build/compiler results/compiler-$side
    fi
    [ -x results/compiler-$side ] || { log "no $side compiler"; exit 1; }
done
sha256sum results/compiler-* > results/compilers.sha256
if [ ! -d corpus/sqlite ]; then
    (cd head && timeout 900 "$X" bash tools/ci/fetch-corpus.sh "$D/corpus" > "$D/corpus.log" 2>&1)
    log "corpus status $?"
fi
for i in $(seq 1 1000); do printf 'int main%d(void) { return %d + x[%d] * 3; }\n' $i $i $i; done > mid.c
# The lexer's programs: Tier 0, --tier1 by head and by base, clang -O2; the harness fails on any difference in output.
rm -rf rows && mkdir -p rows
log "rows harness"
(cd head && timeout 2400 "$X" taskset -c 2 "$D/results/compiler-head" measure-tier1-rows --clang "$(command -v clang)" --base "$D/results/compiler-base" --lexer "$D/mid.c" --directory "$D/rows" --keep > "$D/results/rows.log" 2>&1)
log "rows harness status $?"
R=$(ls -d rows/measure-tier1-rows-* | head -1)
sha256sum $R/lexer-base $R/lexer-tier1 $R/lexer-clang2 $R/lexer-base.o $R/lexer-tier1.o > results/programs.sha256 2>&1
for round in 1 2 3; do
    for program in lexer-base lexer-tier1 lexer-clang2; do
        for input in mid src; do
            target=$D/mid.c; [ $input = src ] && target=$D/head/src
            timeout 900 "$X" taskset -c 2 $R/$program $target > "$D/results/$program-$input-$round.log" 2>&1
            log "$program $input $round status $? $(grep 'c_tokenize ' results/$program-$input-$round.log | tr -s ' ')"
        done
    done
done
# Whole-driver compile time, time-runs under ab: base, head and base again, three copies each, a round a hold.
B="--build base $D/results/compiler-base --build head $D/results/compiler-head --build base-again $D/results/compiler-base"
LEXER="--tier1 -fno-asynchronous-unwind-tables -march=znver5 -I$D/head/src -fwrapv -funsigned-char -fno-strict-aliasing -c $D/head/src/buster/compiler/c_lexer_benchmark.c -o $D/out-lexer.o"
C=$D/corpus
SQLITE="--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include -c $C/sqlite/sqlite3.c -o $D/out-sqlite.o"
for side in base head; do
    for args in "$LEXER" "$SQLITE" "--tier1 $SQLITE"; do
        timeout 600 results/compiler-$side $args > /dev/null 2>&1
        log "drive check $side status $? :: ${args:0:40}"
    done
done
log "ab lexer"
timeout 3600 results/compiler-head ab --rounds 3 --cpu 2 --lock "$X" "$D/results/compiler-head" -- time-runs --runs 3 --copies 3 $B --list $LEXER > results/ab-lexer.log 2>&1
log "ab lexer status $?"
log "ab sqlite tier0"
timeout 3600 results/compiler-head ab --rounds 3 --cpu 2 --lock "$X" "$D/results/compiler-head" -- time-runs --runs 3 --copies 3 $B --list $SQLITE > results/ab-sqlite.log 2>&1
log "ab sqlite tier0 status $?"
log "ab sqlite tier1"
timeout 3600 results/compiler-head ab --rounds 3 --cpu 2 --lock "$X" "$D/results/compiler-head" -- time-runs --runs 2 --copies 2 $B --list --tier1 $SQLITE > results/ab-sqlite-tier1.log 2>&1
log "ab sqlite tier1 status $?"
{ uname -r; grep -m1 'model name' /proc/cpuinfo; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null; } > results/host.txt 2>&1
rm -rf base/build head/build
log "done"
touch run.done
