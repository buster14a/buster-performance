#!/usr/bin/env bash
# buster#2744: why the head's --tier1 compile of the lexer's unit waits ~1 to 32 ms off the CPU (ab-lexer.log) where
# main's never does. After run4.sh. One hold for the syscall counts, ab's own holds for the A/B without the exit helper.
set -uo pipefail
D=$HOME/buster-fast-bench/2744-claude
export EXCLUSIVE_OWNER=claude-2744
export EXCLUSIVE_TITLE="GitHub issue #2744 (Tier 1 literal pool, idle-time diagnosis)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2794
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D" || exit 1
echo $$ > diag.pid
log() { echo "$(date -u +%FT%TZ) $*" >> "$D/diag.log"; }
while [ ! -f run4.done ] && systemctl --user is-active -q claude-2744-r4; do sleep 20; done
log start
LEXER="--tier1 -fno-asynchronous-unwind-tables -march=znver5 -I$D/head/src -fwrapv -funsigned-char -fno-strict-aliasing -c $D/head/src/buster/compiler/c_lexer_benchmark.c -o $D/out-diag.o"
cat > counts.sh <<'COUNTS'
#!/usr/bin/env bash
D=$1; shift
for side in base head base head; do
    timeout 120 taskset -c 2 strace -f -c -o "$D/results/strace-$side.txt" -e trace=clone,clone3,futex,nanosleep,clock_nanosleep,sched_yield,exit_group,munmap,madvise "$D/results/compiler-$side" "$@" > /dev/null 2>&1
    echo "strace $side status $?"
    timeout 120 perf stat -e task-clock,context-switches,cpu-migrations -o "$D/results/perf-$side.txt" taskset -c 2 "$D/results/compiler-$side" "$@" > /dev/null 2>&1
    echo "perf $side status $?"
done
COUNTS
chmod +x counts.sh
"$X" ./counts.sh "$D" $LEXER >> diag.log 2>&1
log "counts status $?"
B="--build base $D/results/compiler-base --build head $D/results/compiler-head --build base-again $D/results/compiler-base"
BUSTER_EXIT_HELPER=0 results/compiler-head ab --rounds 2 --cpu 2 --lock "$X" "$D/results/compiler-head" -- time-runs --runs 3 --copies 3 $B --list $LEXER > results/ab-lexer-no-exit-helper.log 2>&1
log "ab lexer without the exit helper status $?"
log done
touch diag.done
