#!/bin/bash
# #442's paired 9700X record: build the four trees, then rounds of benchmark-emit-ab, every build and run taking the
# shared lock on its own (exclusive.sh), each run pinned to CPU 2, a pause between runs so that waiting CI jobs get in.
D=~/buster-fast-bench/442-claude-merged
cd "$D" || exit 1
# Wait for the first queue (the four trees) to finish, so that the two never take turns at the lock.
while ! grep -q "^done" ~/buster-fast-bench/442-claude/progress.log 2>/dev/null; do sleep 60; done
export EXCLUSIVE_OWNER=claude-442-emit-ab
export EXCLUSIVE_TITLE="#442: paired 9700X A/B of the -c path after checking (main at 335424b1 against PR #517 merged on it (29cb281f))"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/517"
LOCK=~/buster-fast-bench/exclusive.sh
L="$D/progress.log"
unset CPATH C_INCLUDE_PATH
mkdir -p manifests logs
{ uname -a; echo; lscpu; echo; clang --version; echo; ld --version | head -1; echo; cat /sys/devices/system/clocksource/clocksource0/current_clocksource; } > manifests/host.txt 2>&1
for t in mainnow merged; do
    (cd "$D/trees/$t" && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum) > "manifests/source-$t.sha256"
done
for t in mainnow merged; do
    (cd "$D/trees/$t" && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 $LOCK ./build.sh) > "logs/build-$t.log" 2>&1
    echo "build $t exit=$? $(date -Is)" >> "$L"
    sleep 10
done
for t in mainnow merged; do
    echo "$t $(sha256sum manifests/source-$t.sha256 | cut -c1-64) $(sha256sum trees/$t/build/compiler | cut -c1-64)"
done > manifests/trees.txt
run_rounds() {
    local out=$1 rounds=$2 files=$3
    mkdir -p "$out"
    local trees=(mainnow merged)
    for ((r = 1; r <= rounds; r++)); do
        for ((k = 0; k < 2; k++)); do
            local t=${trees[$(((k + r - 1) % 2))]}
            $LOCK taskset -c 2 "$D/trees/$t/build/compiler" benchmark-emit-ab --passes 101 $files > "$out/round-$r-$t.txt" 2> "$out/round-$r-$t.err"
            echo "$(basename $out) round $r $t exit=$? $(grep totals "$out/round-$r-$t.txt") $(date -Is)" >> "$L"
            sleep 10
        done
    done
}
run_rounds "$D/logs/rounds-c-testsuite" 6 "$(ls ~/buster-fast-bench/442-claude/cts/tests/single-exec/*.c | tr '\n' ' ')"
run_rounds "$D/logs/rounds-synthetic" 4 "$(ls ~/buster-fast-bench/442-claude/synthetic/*.c | tr '\n' ' ')"
echo "done $(date -Is)" >> "$L"
