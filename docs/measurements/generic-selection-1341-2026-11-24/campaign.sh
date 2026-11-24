#!/usr/bin/env bash
set -euo pipefail

if [[ ${1:-} == observe ]]; then
    shift
    log="$ROOT/results/zen5-9700x/host-${!#}.log"
    snapshot() {
        date -u
        cat /proc/loadavg
        grep -E '^(MemAvailable|SwapFree|AnonHugePages)' /proc/meminfo
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -10 || true
    }
    cat /var/lib/buster-9700x/owner >> "$log"
    snapshot >> "$log"
    status=0
    "$@" || status=$?
    snapshot >> "$log"
    exit "$status"
fi

export BENCH_ROOT=$PWD REPOSITORY=$PWD/src
export MICROARCH_OWNER=codex-1341-6b055822 MICROARCH_TITLE="Buster #1341 acceptance"
export MICROARCH_LINK=https://github.com/buster14a/buster/issues/1341
export VARIANTS=current SELF_VARIANTS=current PAUSE=1
release=$BENCH_ROOT/historical/microarchitecture-two-hosts-2026-11-04-executables/bin
for name in reference current; do
    export ROOT=$BENCH_ROOT/campaign-$name
    mkdir -p "$ROOT/bin"
    ln -sfn "$BENCH_ROOT/inputs/$name.i" "$ROOT/self-main.i"
    ln -sfn "$BENCH_ROOT/inputs/predefines-znver5.h" "$ROOT/predefines-znver5.h"
    ln -sfn "$BENCH_ROOT/uarch" "$ROOT/uarch"
    ln -sfn "$REPOSITORY/build/compiler" "$ROOT/bin/compiler-current"
    if [[ $name == reference ]]; then
        ln -sfn "$release/compiler-pre1049-znver5" "$ROOT/bin/compiler-pre1049"
        ln -sfn "$release/compiler-znver5" "$ROOT/bin/compiler-regression"
        export AB_BUILDS="pre1049 regression current"
        steps=(ab-self generic-scaling)
    else
        export AB_BUILDS=current
        steps=(ab-self)
    fi
    bash "$REPOSITORY/tools/microarch/run.sh" "$BENCH_ROOT/host.sh" "${steps[@]}" > "$ROOT/driver.log" 2>&1
done
