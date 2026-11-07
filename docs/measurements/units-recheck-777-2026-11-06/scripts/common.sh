# Sourced by the scripts of #777's re-check on the 9700X (Claude Code cloud session).
set -u
W=$HOME/buster-fast-bench/777-claude-cloud
export TMPDIR=$W/tmp
mkdir -p $TMPDIR
LINK=${LINK:-https://github.com/buster14a/buster/issues/777}
lock() { EXCLUSIVE_OWNER=claude-777-cloud EXCLUSIVE_TITLE="Solve 777 (Claude Code cloud session)" EXCLUSIVE_LINK="$LINK" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
statuses() { echo "runs with status 0: $(grep -c 'status 0$' $1); other: $(grep -E '^(run|warm-up).*status' $1 | grep -v -c 'status 0$')"; grep -E 'FAILED' $1 | head -3; }
build() {
    local T=$W/$1
    if [ ! -x $T/build/compiler ]; then
        (cd $T && BUSTER_DEBUG_INFO=0 lock ./build.sh > $W/build-$1.log 2>&1; echo "build $1: status $?")
    fi
    [ -x $T/build/compiler ] || { echo "the build of $1 failed"; tail -20 $W/build-$1.log; exit 1; }
    echo "tree $1 commit $(cat $T/COMMIT)"
    sha256sum $T/build/compiler
}
receipts() {
    uname -a; clang --version | head -1; cc --version | head -1; mold --version
    for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference)"; done
    cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag
}
