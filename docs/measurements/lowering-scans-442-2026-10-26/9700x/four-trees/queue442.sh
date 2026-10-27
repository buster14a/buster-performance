#!/bin/bash
# #442's paired 9700X record: build the four trees, then rounds of benchmark-emit-ab, every build and run taking the
# shared lock on its own (exclusive.sh), each run pinned to CPU 2, a pause between runs so that waiting CI jobs get in.
D=~/buster-fast-bench/442-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-442-emit-ab
export EXCLUSIVE_TITLE="#442: paired 9700X A/B of the -c path after checking (main before #418, #418, PR #517's base and head)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/517"
LOCK=~/buster-fast-bench/exclusive.sh
L="$D/progress.log"
unset CPATH C_INCLUDE_PATH
mkdir -p manifests logs
{ uname -a; echo; lscpu; echo; clang --version; echo; ld --version | head -1; echo; cat /sys/devices/system/clocksource/clocksource0/current_clocksource; } > manifests/host.txt 2>&1
for t in main pr head new; do
    (cd "$D/trees/$t" && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum) > "manifests/source-$t.sha256"
done
for t in main pr head new; do
    (cd "$D/trees/$t" && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 $LOCK ./build.sh) > "logs/build-$t.log" 2>&1
    echo "build $t exit=$? $(date -Is)" >> "$L"
    sleep 10
done
for t in main pr head new; do
    echo "$t $(sha256sum manifests/source-$t.sha256 | cut -c1-64) $(sha256sum trees/$t/build/compiler | cut -c1-64)"
done > manifests/trees.txt
(cd cts/tests/single-exec && sha256sum *.c) > manifests/c-testsuite.sha256
(cd synthetic && sha256sum *.c) > manifests/synthetic.sha256
run_rounds() {
    local out=$1 rounds=$2 files=$3
    mkdir -p "$out"
    local trees=(main pr head new)
    for ((r = 1; r <= rounds; r++)); do
        for ((k = 0; k < 4; k++)); do
            local t=${trees[$(((k + r - 1) % 4))]}
            $LOCK taskset -c 2 "$D/trees/$t/build/compiler" benchmark-emit-ab --passes 101 $files > "$out/round-$r-$t.txt" 2> "$out/round-$r-$t.err"
            echo "$(basename $out) round $r $t exit=$? $(grep totals "$out/round-$r-$t.txt") $(date -Is)" >> "$L"
            sleep 10
        done
    done
}
run_rounds "$D/logs/rounds-c-testsuite" 6 "$(ls $D/cts/tests/single-exec/*.c | tr '\n' ' ')"
run_rounds "$D/logs/rounds-synthetic" 4 "$(ls $D/synthetic/*.c | tr '\n' ' ')"
echo "done $(date -Is)" >> "$L"
