#!/usr/bin/env bash
# buster#2745: the compiler's own lexer by --tier1 and Tier 0, main against the branch's head, on the 9700X.
# Every build and run takes the machine's lock by itself (exclusive.sh), one hold a run; `timeout` goes inside the
# lock, so that it limits the command and never the wait.
set -uo pipefail
D=$HOME/buster-fast-bench/2745-claude
BASE=1935a91fbd07b6fec0f6d651c9649bb7f9ef4d3a
HEAD=5d57bda543f3e076c652ed223f09e78445bb9884
export EXCLUSIVE_OWNER=claude-2745
export EXCLUSIVE_TITLE="Lowering: no clear before a vector's whole value (#2745)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2745
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D" || exit 1
echo $$ > run.pid
log() { echo "$(date -u +%FT%TZ) $*" >> "$D/run.log"; }
# One hold: the busiest processes and the load before and after the command, inside the hold.
held() {
    local name=$1
    shift
    "$X" bash -c '
        out=$1; shift
        { date -Is; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$out.before"
        "$@"; status=$?
        { date -Is; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$out.after"
        exit $status' held "$D/procs/$name" "$@"
}
mkdir -p procs
log "start"
if [ ! -d repo/.git ]; then
    git init -q repo && git -C repo remote add origin https://github.com/buster14a/buster
fi
git -C repo fetch -q --depth 1 origin $BASE >> run.log 2>&1 || { log "fetch base failed"; exit 1; }
git -C repo fetch -q --depth 1 origin $HEAD >> run.log 2>&1 || { log "fetch head failed"; exit 1; }
[ -d base ] || git -C repo worktree add -q --detach "$D/base" $BASE >> run.log 2>&1
[ -d head ] || git -C repo worktree add -q --detach "$D/head" $HEAD >> run.log 2>&1
for side in base head; do
    if [ ! -x $side/build/compiler ]; then
        log "build $side"
        (cd $side && held build-$side timeout -k 10 2400 ./build.sh --config Release > "$D/build-$side.log" 2>&1)
        log "build $side status $? $(tail -1 build-$side.log)"
    fi
    [ -x $side/build/compiler ] || { log "no $side compiler"; exit 1; }
    cp $side/build/compiler "$D/compiler-$side"
done
sha256sum compiler-base compiler-head > compilers.sha256
for i in $(seq 1 1000); do printf 'int main%d(void) { return %d + x[%d] * 3; }\n' $i $i $i; done > mid.c
rm -rf rows && mkdir -p rows
log "rows harness (mid.c, with --base)"
(cd head && held rows timeout -k 10 1800 taskset -c 2 ./build/compiler measure-tier1-rows --clang "$(command -v clang)" --base "$D/base/build/compiler" --lexer "$D/mid.c" --directory "$D/rows" --keep > "$D/rows.log" 2>&1)
log "rows harness status $?"
R=$(ls -d rows/measure-tier1-rows-* | head -1)
ls $R > rows-files.txt 2>&1
(cd $R && sha256sum lexer-base lexer-tier1 lexer-tier0 lexer-clang2 lexer-base.o lexer-tier1.o lexer-tier0.o) > programs.sha256 2>&1
for program in lexer-tier0 lexer-base lexer-tier1 lexer-clang2; do
    test -x $R/$program || { log "no $program"; continue; }
    for input in mid src; do
        target=$D/mid.c
        [ $input = src ] && target=$D/head/src
        for run in 1 2 3; do
            held $program-$input-$run timeout -k 10 900 taskset -c 2 $R/$program $target > "$D/$program-$input-$run.log" 2>&1
            log "$program $input $run status $? $(grep 'c_tokenize ' $program-$input-$run.log | tr -s ' ')"
        done
    done
done
{ uname -r; grep -m1 'model name' /proc/cpuinfo; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null; } > host.txt 2>&1
log "done"
touch run.done
