#!/usr/bin/env bash
# buster#1344, PR #2742: the compiler's own lexer by --tier1, the branch's merge base against its head, on the 9700X.
# Every build and run takes the machine's lock by itself (exclusive.sh), one hold a run.
set -uo pipefail
D=$HOME/buster-fast-bench/1344-claude
BASE=ca2bd994a39e0590c3c761ffbb9f80ad66407ef8
HEAD=dd71e6a5409827cd5bf1c35a2ee8f76dedfff020
export EXCLUSIVE_OWNER=claude-1344
export EXCLUSIVE_TITLE="Buster compiler vector performance (#1344)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2742
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D" || exit 1
log() { echo "$(date -u +%FT%TZ) $*" >> "$D/run.log"; }
log "start"
if [ ! -d repo/.git ]; then
    git init -q repo && git -C repo remote add origin https://github.com/buster14a/buster
fi
git -C repo fetch -q --depth 1 origin $BASE $HEAD >> run.log 2>&1 || { log "fetch failed"; exit 1; }
[ -d base ] || git -C repo worktree add -q --detach "$D/base" $BASE >> run.log 2>&1
[ -d head ] || git -C repo worktree add -q --detach "$D/head" $HEAD >> run.log 2>&1
for side in base head; do
    if [ ! -x $side/build/compiler ]; then
        log "build $side"
        (cd $side && timeout 2400 "$X" ./build.sh --config Release > "$D/build-$side.log" 2>&1)
        log "build $side status $? $(tail -1 build-$side.log)"
    fi
    [ -x $side/build/compiler ] || { log "no $side compiler"; exit 1; }
done
for i in $(seq 1 1000); do printf 'int main%d(void) { return %d + x[%d] * 3; }\n' $i $i $i; done > mid.c
rm -rf rows && mkdir -p rows
log "rows harness (mid.c, with --base)"
(cd head && timeout 1800 "$X" taskset -c 2 ./build/compiler measure-tier1-rows --clang "$(command -v clang)" --base "$D/base/build/compiler" --lexer "$D/mid.c" --directory "$D/rows" --keep > "$D/rows.log" 2>&1)
log "rows harness status $?"
R=$(ls -d rows/measure-tier1-rows-* | head -1)
ls $R > rows-files.txt 2>&1
for program in $(ls $R | grep '^lexer-' | grep -v '\.'); do
    for input in mid src; do
        target=$D/mid.c; [ $input = src ] && target=$D/head/src
        for run in 1 2 3; do
            timeout 900 "$X" taskset -c 2 $R/$program $target > "$D/$program-$input-$run.log" 2>&1
            log "$program $input $run status $? $(grep 'c_tokenize ' $program-$input-$run.log | tr -s ' ')"
        done
    done
done
{ uname -r; grep -m1 'model name' /proc/cpuinfo; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null; } > host.txt 2>&1
log "done"
